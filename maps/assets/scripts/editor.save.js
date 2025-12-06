var JSONLayers = [];

function CancelButton() {
	swal({
		title: "Annulation",
		text: "Êtes vous sur de vouloir annuler",
		type: "warning",
		showCancelButton: false,
		confirmButtonColor: "#d32300",
		confirmButtonText: "Yes",
		closeOnConfirm: true
	},
	function(){
		location.reload();
	});
}

async function generateGeoJson(){
	const pathname = parsePathName();
    const search = parseSearch();
	console.log(JSONLayers);
	if (pathname.option != '') {
		let url = 'api/put/'+pathname.option+'.php?';
		let i=0;
		for (one in search) {
			if (i!=0) { url += '&'; }
			url += one+'='+search[one];
			i++;
		}
		url += '&dim='+pathname.data+'&d='+JSON.stringify(JSONLayers);
		try {
			const response = await fetch(url);
			if (!response.ok) {
			  	throw new Error(`Response status: ${response.status}`);
			}
			const res = await response.json();
			console.log(res);
			// const datas = res.posts;
			swal({
				title: "",
				text: res.status,
				type: res.code,
				showCancelButton: false,
				confirmButtonColor: "#2E3144",
				confirmButtonText: "Ok",
				closeOnConfirm: true
			},
			function(){
				if (res.code == 'success') {
					location.reload();
				}
			});
		} catch (error) {
			console.error(error.message);
			swal({
				title: "Oops...",
				text: "L'opération n'a pas abouti",
				type: "error",
				showCancelButton: false,
				confirmButtonColor: "#d32300",
				confirmButtonText: "Ok",
				closeOnConfirm: true
			});
		}
	}
}