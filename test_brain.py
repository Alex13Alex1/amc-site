import os

from crewai import Agent, Crew, LLM, Process, Task


def main() -> None:
    # Never hardcode secrets in source code.
    # Set it in your shell instead:
    #   export OPENAI_API_KEY="sk-..."
    #   export OPENAI_MODEL_NAME="gpt-4o-mini"  # optional
    if not os.getenv("OPENAI_API_KEY"):
        raise RuntimeError(
            "Missing OPENAI_API_KEY. Set it in your environment, e.g.\n"
            '  export OPENAI_API_KEY="sk-..."\n'
            '  export OPENAI_MODEL_NAME="gpt-4o-mini"  # optional\n'
        )

    llm = LLM(model=os.getenv("OPENAI_MODEL_NAME", "gpt-4o-mini"))

    # 1. СОЗДАЕМ АГЕНТОВ
    ideator = Agent(
        role="Футуролог",
        goal="Придумать невероятную технологию будущего",
        backstory="Ты визионер. Ты генерируешь идеи, которые изменят мир.",
        verbose=True,
        allow_delegation=False,
        llm=llm,
    )

    critic = Agent(
        role="Скептик",
        goal="Найти ошибки в идее Футуролога",
        backstory="Ты строгий эксперт. Ты анализируешь риски.",
        verbose=True,
        allow_delegation=False,
        llm=llm,
    )

    # 2. СОЗДАЕМ ЗАДАЧИ
    task1 = Task(
        description="Придумай концепцию умного ошейника для перевода языка котов на человеческий.",
        agent=ideator,
        expected_output="Четкое описание идеи в 3 предложениях.",
    )

    task2 = Task(
        description="Прочитай идею Футуролога и напиши 3 причины, почему это сложно реализовать.",
        agent=critic,
        expected_output="Список из 3 рисков.",
        context=[task1],
    )

    # 3. ЗАПУСКАЕМ КОМАНДУ
    my_crew = Crew(
        agents=[ideator, critic],
        tasks=[task1, task2],
        verbose=True,
        process=Process.sequential,
    )

    print("### ЗАПУСК АВТОНОМНОГО ОБЩЕНИЯ ###")
    result = my_crew.kickoff()

    print("\n\n########################")
    print(result)


if __name__ == "__main__":
    main()

