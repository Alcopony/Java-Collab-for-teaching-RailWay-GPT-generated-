# JupyterLab + Java kernel for Railway

This project deploys a single-user JupyterLab instance with:
- Java kernel via `jupyter-java` / `jbang`
- JupyterLab 4.4.x
- `jupyter-collaboration` 4.4.1
- persistent notebook storage in `/data`

## Railway setup

1. Deploy this repo from GitHub.
2. Add a **Volume** mounted at `/data`.
3. Add the environment variable:

   `JUPYTER_PASSWORD=your-strong-password`

4. Optional tweaks:

   - `YDOC_SAVE_DELAY=0.5`
   - `YSTORE_DB_PATH=/data/.jupyter_ystore.db`
   - `JUPYTER_ROOT_DIR=/data`

5. In **Networking**, generate a public domain.
6. Open the URL and log in with `JUPYTER_PASSWORD`.

## First test

Create a new notebook with the **java (JJava/j!)** kernel and run:

```java
System.out.println("Hello, Java!");
```

## Notes on collaboration

This image uses the current `jupyter-collaboration` package for JupyterLab 4.4.
If you test collaboration, open the same notebook in separate workspace URLs, for example:

- `/lab/workspaces/teacher/tree/shared.ipynb?reset`
- `/lab/workspaces/student/tree/shared.ipynb?reset`

Avoid reusing old `RTC:` links from previous sessions.
