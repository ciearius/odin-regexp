# See this: 
# https://github.com/microsoft/vscode-remote-release/issues/8478
echo "Manual install of code extensions"
sleep 5

# https://github.com/microsoft/vscode-remote-release/issues/1042

export PATH=`echo ~/.vscode-server/bin/*/bin`:$PATH
export VSCODE_IPC_HOOK_CLI="$(ls /tmp/vscode-ipc-*.sock  | head -n 1)"
code_server_bin=$(ps -aux | grep "bin/code-server" | awk '{print $12}' | head -n 1)
code_bin=$(dirname "$code_server_bin")/remote-cli/code

echo $VSCODE_IPC_HOOK_CLI
echo $code_bin

extensions_to_install=$(yq eval '.customizations.vscode.extensions | join(" --install-extension ")'  -P ./.devcontainer/devcontainer.json)

echo "$code_bin --install-extension $extensions_to_install"
$code_bin --install-extension $extensions_to_install
