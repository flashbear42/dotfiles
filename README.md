# dotfiles

## Warning!
이 설정 파일들은 아직 테스트되지 않았습니다. 사용에 주의하세요.

## Introduction
스크립트로 MacOS 신규 사용을 위한 초기 파일들을 설치합니다. Xcode Command Line Tools, Rosetta 2 설치를 시작으로 [Fish Shell](https://fishshell.com)등 필수 패키지들을 최소한을 설치하지만, 개인용이기 때문에 모두에게 필수적이진 않을 수 있습니다. 패키지 설치가 끝나면 기본 설정 파일들(`$HOME/.config/`)에 심볼릭 링크<sub>symbolic link</sub>들을 생성하고 종료됩니다.


## Quickstart
```
$ git clone https://github.com/flashbear42/dotfiles
$ cd dotfiles
$ ./bootstrap.sh
```

## Customization
#### dotfiles/git/gitconfig
`name`과 `email` 항목을 자신의 것을 바꾸세요.

#### dotfiles/Brewfile
[Homebrew](https://brew.sh)로 설치되는 패키지들을 변경할 수 있어요.


## Related
- https://github.com/webpro/awesome-dotfiles
