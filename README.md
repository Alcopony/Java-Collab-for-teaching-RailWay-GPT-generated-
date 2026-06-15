# Java JupyterLab for Railway

A ready-to-deploy JupyterLab setup for Railway with:

- Java kernel via `jbang` / `jjava`
- Real-Time Collaboration for teacher + student sessions
- Persistent notebooks via a Railway Volume
- Password-based login

## What the student sees

The student opens your Railway URL in a browser, enters the shared password, and opens the same `.ipynb` notebook as you.

## Files in this repo

- `Dockerfile` — container build for Railway
- `requirements.txt` — Python/Jupyter packages
- `entrypoint.sh` — runtime startup script

## Deploy on Railway

1. Upload this repo to GitHub.
2. In Railway, create a new project from the GitHub repo.
3. Add a **Volume** and mount it to `/data`.
4. Add these Railway variables:
   - `JUPYTER_PASSWORD` — required, set a strong password
   - `JUPYTER_ROOT_DIR=/data` — optional, already default
   - `JUPYTER_COLLABORATIVE=true` — optional, already default
5. Enable **Public Networking** and generate a Railway domain.
6. Open the generated URL.

Railway volumes persist files between restarts, so notebooks stored in `/data` survive redeploys and restarts.

## First login

1. Open the Railway URL.
2. Log in with `JUPYTER_PASSWORD`.
3. Click `+` → `Notebook`.
4. Select the Java kernel (`jjava`).
5. Save the notebook, for example `lesson1.ipynb`.

## Working together in one notebook

To collaborate live:

1. You and the student open the same notebook file.
2. Keep `JUPYTER_COLLABORATIVE=true`.
3. Edit the same notebook together.

JupyterLab RTC supports live edits when `jupyter_collaboration` is installed and JupyterLab is started with `--collaborative`.

## Test cell

Create a notebook with the Java kernel and run:

```java
System.out.println("Hello, Java");
```

## Notes

- This setup is best for **one teacher + one student** using a shared login.
- For multiple students with separate accounts, move later to JupyterHub.
- If you want stricter CORS, set `JUPYTER_ALLOW_ORIGIN` to your exact frontend/domain instead of `*`.

## Recommended Railway settings

- Plan: Hobby is usually enough to start.
- Volume mount path: `/data`
- Password: use a long random password.

## Useful variables

- `JUPYTER_PASSWORD` — required
- `JUPYTER_ROOT_DIR` — default `/data`
- `JUPYTER_COLLABORATIVE` — default `true`
- `JUPYTER_ALLOW_ORIGIN` — default `*`
- `JUPYTER_BASE_URL` — default `/`

## Troubleshooting

### Java kernel does not appear

Check Railway deploy logs and confirm the container completed:

- JBang installation
- `jbang install-kernel@jupyter-java jjava`

### Files disappear after restart

Your Railway Volume is missing or not mounted to `/data`.

### Student cannot connect

Check:

- Public Networking is enabled
- The deployment is healthy
- The password is correct

### Collaboration is not live

Confirm:

- `jupyter-collaboration` is installed
- `JUPYTER_COLLABORATIVE=true`
- You both opened the exact same notebook file
