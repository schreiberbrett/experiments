import os
import glob

keywords =       ['==', '=/=', 'absento', 'conda', 'condu', 'project', '(in', '!in', '(set', 'empty-set']
langs = {
    'trs2e':     [   1,     0,         0,       1,       1,         1,     0,     0,      0,           0],
    'faster-mk': [   1,     1,         1,       0,       0,         1,     0,     0,      0,           0],
    'clp-set':   [   1,     1,         0,       1,       1,         1,     1,     1,      1,           1],
    'frontend':  [   1,     0,         0,       0,       0,         0,     0,     0,      0,           0]
}

def main():
    md_files = glob.glob('**/*.md', recursive=True)

    os.makedirs('dist', exist_ok=True)

    files = {
        k: open(f'dist/{k}.scm', 'w', encoding='utf-8')
        for k in langs
    }


    for file_path in md_files:
        print(f'opening: {file_path}')
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
            scheme_blocks = extract_between(content, '```scheme\n', '```\n')

            for block in scheme_blocks:
                for k in langs:
                    if not any(
                        keywords[i] in block and langs[k][i] == 0
                        for i in range(len(keywords))
                    ):
                        files[k].write(block + '\n\n')


    for k in langs:
        files[k].close()


def extract_between(s: str, start: str, end: str) -> list[str]:
    '''
    Extract all substrings between each occurrence of start and end into a list.
    '''
    results = []
    start_len = len(start)
    end_len = len(end)
    
    # Find the first occurrence of the start string
    start_idx = s.find(start)
    
    # Loop until no more start strings are found
    while start_idx != -1:
        # Find the end string after the start string
        end_idx = s.find(end, start_idx + start_len)
        if end_idx == -1:
            break
        
        # Extract the substring between the start and end strings
        substring = s[start_idx + start_len:end_idx]
        results.append(substring)
        
        # Update start_idx to search for the next occurrence
        start_idx = s.find(start, end_idx + end_len)
    
    return results


if __name__ == '__main__':
    main()