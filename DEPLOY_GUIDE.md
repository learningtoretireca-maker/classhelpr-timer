# ClassTimr Deployment Guide

## Deploying to `timer.classhelpr.com` via GitHub + Railway

---

## Project File Structure

Your project folder should contain exactly these 4 files:

```
classhelpr-timer/
├── index.html      ← Your timer app
├── Dockerfile       ← Tells Railway how to build & serve
├── nginx.conf       ← Nginx server configuration
└── .gitignore       ← Git ignore rules
```

All four files are included in this download. Copy them into a single folder on your machine.

---

## Part 1: Set Up the Project in Cursor

1. Open **Cursor** and go to `File → Open Folder`.
2. Select the `classhelpr-timer` folder containing the 4 files above.
3. Verify in the file explorer sidebar that you see `index.html`, `Dockerfile`, `nginx.conf`, and `.gitignore`.

That's it — the project is ready.

---

## Part 2: Push to GitHub Using Cursor

### Option A: Using Cursor's Built-in Git UI

1. Click the **Source Control** icon in the left sidebar (the branch icon).
2. Click **Initialize Repository**.
3. Stage all files by clicking the `+` next to "Changes".
4. Type a commit message like `Initial commit: ClassTimr app` and click the checkmark to commit.
5. Click **Publish Branch** — Cursor will prompt you to sign into GitHub if you haven't already.
6. Choose **public** or **private** repository, and name it `classhelpr-timer`.
7. Cursor pushes everything to GitHub automatically.

### Option B: Using the Terminal

1. Open Cursor's terminal: `` Ctrl+`  `` (backtick).
2. Run these commands:

```bash
# Initialize git repo
git init

# Stage all files
git add .

# Commit
git commit -m "Initial commit: ClassTimr app"

# Create repo on GitHub (requires GitHub CLI — install with: brew install gh)
gh repo create classhelpr-timer --public --source=. --push

# OR if you prefer manual GitHub setup:
# 1. Go to github.com → New Repository → name it "classhelpr-timer"
# 2. Then run:
git remote add origin https://github.com/YOUR_USERNAME/classhelpr-timer.git
git branch -M main
git push -u origin main
```

---

## Part 3: Deploy on Railway

### 3a. Connect GitHub Repo

1. Go to [railway.app](https://railway.app) and sign in (use GitHub login for easiest setup).
2. Click **New Project** → **Deploy from GitHub Repo**.
3. Select `classhelpr-timer` from the list. If you don't see it, click "Configure GitHub App" to grant Railway access.
4. Railway will auto-detect the `Dockerfile` and begin building immediately.

### 3b. Configure the Port

Railway needs to know which port your container listens on:

1. Click on your deployed service in the Railway dashboard.
2. Go to the **Settings** tab.
3. Under **Networking**, click **Generate Domain** (this gives you a temporary `.railway.app` URL to test with).
4. Go to the **Variables** tab and add: `PORT` = `8080`.
   *(Railway's Nginx config is already set to port 8080, so this ensures they match.)*

### 3c. Verify It Works

1. Wait for the build to complete (usually under 2 minutes).
2. Click the generated `.railway.app` URL — you should see your timer running.

---

## Part 4: Connect Your Custom Domain (`timer.classhelpr.com`)

### 4a. Add the Domain in Railway

1. In your Railway service, go to **Settings** → **Networking** → **Custom Domain**.
2. Type `timer.classhelpr.com` and click **Add**.
3. Railway will display a **CNAME target** — it will look something like: `your-service-production-xxxx.up.railway.app`
4. **Copy this CNAME value exactly.**

### 4b. Configure DNS at Your Domain Provider

Go to your domain provider's DNS settings for `classhelpr.com` and add this record:

| Type  | Name    | Value / Target                                    | TTL  |
|-------|---------|---------------------------------------------------|------|
| CNAME | `timer` | `your-service-production-xxxx.up.railway.app`     | 300  |

**Important notes:**
- The **Name** field is just `timer` (not the full `timer.classhelpr.com` — most providers append the root domain automatically).
- The **Value** is the CNAME target Railway gave you in step 4a.
- TTL of 300 (5 minutes) is fine; some providers may default to 3600.

### 4c. Wait for Propagation & SSL

- DNS changes can take anywhere from 2 minutes to 48 hours (usually under 30 minutes).
- Railway automatically provisions a free SSL certificate once the CNAME resolves correctly.
- You can check propagation at [dnschecker.org](https://dnschecker.org) — search for `timer.classhelpr.com` and look for your CNAME.

### 4d. Verify

Once DNS has propagated, visit **https://timer.classhelpr.com** — your ClassTimr app should be live with HTTPS.

---

## Ongoing: Auto-Deploy on Code Changes

Because Railway is connected to your GitHub repo, any time you push a new commit, Railway will automatically rebuild and deploy. Your workflow becomes:

1. Edit `index.html` in Cursor.
2. Commit & push to GitHub.
3. Railway deploys automatically within ~2 minutes.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Railway build fails | Check the build logs — usually a Dockerfile syntax issue. Make sure all 3 project files are committed. |
| Site shows "502 Bad Gateway" | The container may still be starting. Wait 30 seconds and refresh. Also verify `PORT=8080` is set in Railway variables. |
| Custom domain not resolving | Double-check the CNAME record at your DNS provider. Use dnschecker.org to verify. DNS propagation can take up to 48 hours. |
| SSL certificate not working | Railway auto-provisions SSL after DNS resolves. If the CNAME is correct, just wait a few minutes. |
| Site works on `.railway.app` but not custom domain | The DNS hasn't propagated yet, or the CNAME value is wrong. Compare it exactly with what Railway shows. |
