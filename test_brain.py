import os

from crewai import Agent, Crew, LLM, Process, Task


def main() -> None:
    # Don't hardcode secrets in source code.
    # Set it in your shell instead: export OPENAI_API_KEY="sk-..."
    if not os.getenv("OPENAI_API_KEY"):
        raise RuntimeError(
            "Missing OPENAI_API_KEY. Set it in your environment, e.g.\n"
            '  export OPENAI_API_KEY="sk-..."\n'
            '  export OPENAI_MODEL_NAME="gpt-4o-mini"  # optional\n'
        )

    llm = LLM(model=os.getenv("OPENAI_MODEL_NAME", "gpt-4o-mini"))

    # 2. СОЗДАНИЕ АГЕНТОВ (РОЛИ)
    ideator = Agent(
        role="Футуролог",
        goal="Придумать безумную, но теоретически возможную технологию будущего",
        backstory="Ты визионер, который видит мир через 100 лет.",
        verbose=True,  # показывает ход рассуждений/лог агента
        allow_delegation=False,
        llm=llm,
    )

    critic = Agent(
        role="Злой Инвестор",
        goal="Найти слабые места в идее Футуролога и разнести её в пух и прах",
        backstory=(
            "Ты прагматик, который ненавидит пустые фантазии. "
            "Ты ищешь причины, почему это НЕ сработает."
        ),
        verbose=True,
        allow_delegation=False,
        llm=llm,
    )

    # 3. СОЗДАНИЕ ЗАДАЧ (СВЯЗЬ)
    task1 = Task(
        description="Придумай концепцию гаджета для чтения мыслей котов.",
        agent=ideator,
        expected_output="Короткое описание гаджета (3-4 предложения).",
    )

    task2 = Task(
        description="Проанализируй идею Футуролога и напиши 3 причины, почему это провалится.",
        agent=critic,
        expected_output="Список из 3 критических замечаний.",
        context=[task1],
    )

    # 4. СБОРКА МОЗГА (КОМАНДА)
    brain_crew = Crew(
        agents=[ideator, critic],
        tasks=[task1, task2],
        verbose=True,
        process=Process.sequential,
    )

    # 5. ЗАПУСК
    print("### ЗАПУСК АВТОНОМНОЙ СИСТЕМЫ ###")
    result = brain_crew.kickoff()

    print("\n\n########################")
    print("## ИТОГОВЫЙ РЕЗУЛЬТАТ ##")
    print("########################\n")
    print(result)


if __name__ == "__main__":
    main()

