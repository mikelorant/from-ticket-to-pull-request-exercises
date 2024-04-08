FROM alpine:edge as gum
RUN apk add --no-cache \
      gum

FROM golang:alpine as dependencies
RUN apk add --no-cache \
      bash \
      less \
      git \
      git-bash-completion \
      git-prompt \
      nano \
      vim
COPY --from=gum /usr/bin/gum /usr/bin/

FROM dependencies as repository
RUN git clone https://github.com/mikelorant/markdown-viewer.git /usr/src/app
WORKDIR /usr/src/app

FROM repository as build
RUN go mod download

FROM build as release
ENV GIT_PS1_SHOWDIRTYSTATE 1
ENV GIT_PS1_SHOWSTASHSTATE 1
ENV GIT_PS1_SHOWUNTRACKEDFILES 1
ENV GIT_PS1_SHOWUPSTREAM auto
ENV GIT_PS1_SHOWCOLORHINTS 1
ENV PROMPT_COMMAND '__git_ps1 "\w" " \\\$ "'
ENV CLICOLOR_FORCE=1
RUN ln -s /usr/share/git-core/git-prompt.sh /etc/profile.d/
COPY <<EOF /etc/vim/vimrc.local
set nofixendofline
set textwidth=72
EOF
COPY --link docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

FROM release as exercise-1
ARG NAME
ARG EMAIL
RUN git branch chapter-2
RUN git reset --hard HEAD~3
RUN git switch chapter-2
RUN git reset --hard HEAD~2
RUN git apply --unidiff-zero <<-EOT
diff --git a/assets/index.html b/assets/index.html
index ddb88ac..c9caf29 100644
--- a/assets/index.html
+++ b/assets/index.html
@@ -7,0 +8 @@
+        font-size: 24px;
diff --git a/content.md b/content.md
index 97c2707..9c1a14c 100644
--- a/content.md
+++ b/content.md
@@ -10,2 +9,0 @@ them keep track of their code and work together harmoniously.
-![chapter-1](assets/images/chapter-1.jpg)
-
EOT
RUN git add --all
RUN git -c "user.name=${NAME}" -c "user.email=${EMAIL}" commit --amend --no-edit --reset-author

FROM release as exercise-2
ARG NAME
ARG EMAIL
RUN apk add --no-cache \
      patchutils
RUN git branch chapter-3
RUN git reset --hard HEAD~2
RUN git switch chapter-3
RUN git reset --hard HEAD~1
RUN git apply --unidiff-zero <<-EOT
diff --git a/content.md b/content.md
index 6c04212..7fa98ba 100644
--- a/content.md
+++ b/content.md
@@ -33 +33 @@ code, restoring it to its previous state with a simple incantation.
-As Sarah's Git sorcery skills grew, she learned the importance of crafting
+As Sarah's Giiit sorcery skills grew, she learned the importance of crafting
@@ -38,2 +37,0 @@ and restructuring them into a cohesive, magical tapestry.
-![chapter-3](assets/images/chapter-3.jpg)
-
EOT
RUN git add --all
RUN git -c "user.name=${NAME}" -c "user.email=${EMAIL}" commit --amend --reset-author --message "Text"
RUN git diff ..origin/main~1 --unified=0 | \
    grepdiff --output-matching=hunk images | \
    git apply --unidiff-zero
RUN git add --all
RUN git -c "user.name=${NAME}" -c "user.email=${EMAIL}" commit --message "Image"
RUN git restore --source=origin/main~1 .

FROM gitea/gitea:1.21 as importer
USER root
RUN apk add --no-cache \
      shadow \
      wait4x
RUN usermod --home /tmp git
COPY <<-EOT /docker-entrypoint.sh
#!/usr/bin/env bash
wait4x http http://server:3000 --timeout 120s --quiet
gitea admin user create --username="\${USERNAME}" --email="\${EMAIL}" --password="\${PASSWORD}" --admin --must-change-password=false
cd /tmp
git clone https://github.com/mikelorant/markdown-viewer.git
cd markdown-viewer
git config --global user.name "\${NAME}"
git config --global user.email "\${EMAIL}"
git config --global credential.helper store
git config --global push.autoSetupRemote true
cat <<-EOF >\$HOME/.git-credentials
https://\${USERNAME}:\${PASSWORD}@\${REPOSITORY}
EOF
git reset --hard HEAD~2
git remote set-url origin https://\${REPOSITORY}/\${USERNAME}/markdown-viewer.git
git push
sleep infinity
EOT
RUN chmod +x /docker-entrypoint.sh
USER git
ENTRYPOINT ["/docker-entrypoint.sh"]

FROM release
