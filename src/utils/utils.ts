export function sanitizeInput(input: string): string {
    const sanitizedInput = input.replace(/['";\\]/g, '');
    const sanitizedHTML = sanitizedInput.replace(/<[^>]*>/g, '');
  
    const sqlKeywords = ['SELECT', 'DELETE', 'INSERT', 'UPDATE', 'DROP', 'EXECUTE', 'UNION', 'ALTER', 'CREATE', 'TABLE'];
    let sanitizedSQL = sanitizedHTML;
    sqlKeywords.forEach(keyword => {
      const regex = new RegExp('\\b' + keyword + '\\b', 'gi');
      sanitizedSQL = sanitizedSQL.replace(regex, '');
      sanitizedSQL = sanitizedSQL.replace(/--/g, '');
    });
  
    const trimmedInput = sanitizedSQL.trim();
    return trimmedInput;
  }


  export function arrayBufferToBase64(buffer: number[]) {
    var binary = '';
    var bytes = new Uint8Array(buffer);
    var len = bytes.byteLength;
    for (var i = 0; i < len; i++) {
        binary += String.fromCharCode(bytes[i]);
    }
    return 'data:image/jpeg;base64,' + window.btoa(binary);
}