---


---

<h3 id="interrogating-windows-service-logs">Interrogating Windows Service Logs</h3>
<pre class=" language-powershell"><code class="prism  language-powershell"><span class="token keyword">function</span> Tr1p<span class="token operator">-</span>ServiceRecords<span class="token punctuation">(</span><span class="token variable">$serviceName</span><span class="token punctuation">)</span>  
<span class="token punctuation">{</span>
	<span class="token function">Get-EventLog</span> <span class="token operator">-</span>LogName System <span class="token punctuation">|</span> ? <span class="token punctuation">{</span><span class="token variable">$_</span><span class="token punctuation">.</span>Message <span class="token operator">-</span>ilike <span class="token string">"**<span class="token variable">$serviceName</span>**"</span><span class="token punctuation">}</span><span class="token punctuation">|</span> <span class="token function">select</span> `
	Message<span class="token punctuation">,</span> TimeGenerated<span class="token punctuation">,</span> TimeWritten<span class="token punctuation">,</span> UserName <span class="token punctuation">|</span> <span class="token operator">%</span> <span class="token punctuation">{</span><span class="token namespace">[PSCustomObject]</span>@<span class="token punctuation">{</span>`
		<span class="token string">"ServiceName"</span>=<span class="token variable">$serviceName</span><span class="token punctuation">;</span>`
		<span class="token string">"TimeGenerated"</span>=<span class="token variable">$_</span><span class="token punctuation">.</span>TimeGenerated<span class="token punctuation">;</span>`
		<span class="token string">"TimeWritten"</span>=<span class="token variable">$_</span><span class="token punctuation">.</span>TimeWritten<span class="token punctuation">;</span>`
		<span class="token string">"Message"</span>=<span class="token variable">$_</span><span class="token punctuation">.</span>Message<span class="token punctuation">;</span>`
		<span class="token string">"UserName"</span>=<span class="token variable">$_</span><span class="token punctuation">.</span>UserName
		<span class="token punctuation">}</span>
	<span class="token punctuation">}</span>  
<span class="token punctuation">}</span>
</code></pre>

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEwMTcwNzY3MzhdfQ==
-->