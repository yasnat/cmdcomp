from pathlib import Path

from cmdcomp.shell import ShellType
from cmdcomp.v2.config import V2Config


def generate_v2(shell: ShellType, config: V2Config) -> str:
    from jinja2 import Environment, FileSystemLoader

    env = Environment(
        loader=FileSystemLoader(Path(__file__).parent / "templates"),
    )
    template = env.get_template(f"{shell.value}.sh.jinja")

    return template.render(
        app_name=config.app.name,
        app_aliases=config.app.aliases + config.root.aliases,
        commands={config.app.name: config.root},
    )
