from functools import reduce
from pathlib import Path

from mergedeep import merge

from cmdcomp.config.command.command import (
    Candidates,
    Command,
    Completions,
    SubCommandsCommand,
    get_candidates,
    get_targets,
)
from cmdcomp.config.config import Config
from cmdcomp.shell_type import ShellType


def generate(shell: ShellType, config: Config):
    from jinja2 import Environment, FileSystemLoader

    env = Environment(
        loader=FileSystemLoader(Path(__file__).parent / "templates"),
    )
    template = env.get_template(f"{shell.value}.sh.jinja")

    return template.render(
        app_name=config.app.name,
        app_aliases=config.root.aliases,
        completions_list=generate_completions_list(config),
    )


def generate_completions_list(config: Config):
    completions_list = [get_candidates(config.root)]

    _update_completions_list(
        completions_list,
        config.root,
    )

    return completions_list


def _update_completions_list(
    completions_list: list[Completions],
    command: Command,
    keys: list[str] | None = None,
):
    if keys is None:
        keys = []

    if not isinstance(command, SubCommandsCommand):
        return

    for name, subcommand in command.subcommands.items():
        new_keys = keys + ["|".join(get_targets(name, subcommand))]

        _update_completions_list(completions_list, subcommand, new_keys)

        candidates: Candidates = get_candidates(subcommand)

        if len(candidates) == 0:
            continue

        while len(completions_list) < len(new_keys) + 1:
            completions_list.append({})

        merge(
            completions_list[len(new_keys)],  # type: ignore
            reduce(
                _swap_key_value,  # type: ignore
                reversed(new_keys),
                candidates,  # type: ignore
            ),
        )


def _swap_key_value(prev: Completions, key: str) -> Completions:
    return {key: prev}
