var catTipoTransaccionTipoClav = {
	'elimina' : '1',
	'agrega' : '2',
	'modifica' : '3'
};

var clavesPresupuestales = [];

$(document).ready(function(){
	esTab = true;

	$("#institNominaID").focus();
	deshabilitaBoton('graba', 'submit');
	deshabilitaBoton('elimina', 'submit');
	consultaGridClavePresup();

	$.validator.setDefaults({submitHandler : function(event) {
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','institNominaID','exitoTransParametro','falloTransParametro');
		}
	});

	/***********MANEJO DE EVENTOS******************/
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab = true;
		}
	});

	$('#graba').click(function() {
		var nomClaveConvenioID = $('#nomClaveConvenioID').val();
		if(nomClaveConvenioID == 0 && nomClaveConvenioID != '' && nomClaveConvenioID != null){
			$('#tipoTransaccion').val(catTipoTransaccionTipoClav.agrega);
		}else if(nomClaveConvenioID > 0 && nomClaveConvenioID != '' && nomClaveConvenioID != null){
			$('#tipoTransaccion').val(catTipoTransaccionTipoClav.modifica);
		}
	});

	$('#elimina').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionTipoClav.elimina);
	});
/*========================================  CONSULTA DEL LISTADO DE PRODUCTO DE CREDITO ================================ */
	$('#institNominaID').bind('keyup',function(e) {
		lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
	});

	$('#institNominaID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		var institNominaID = $('#institNominaID').val();
		var numCodig = $('#numero').val();
		for(var i = 1; i <= numCodig; i++){
			var jqIdReqClave = eval("'reqClave" + i+ "'");
			$('#'+jqIdReqClave).attr('checked',false);
		}
		if(esTab){
			if(institNominaID > 0 && institNominaID != '' && institNominaID != null){
				consultaInstitucionNomina();
				consultaGridClavePresupConv();
			}else if(institNominaID != ''){
				$("#institNominaID").val("");
				$("#descripcion").val("");
				deshabilitaBoton('graba', 'submit');
				deshabilitaBoton('elimina', 'submit');
				mensajeSis("Espeficique un Tipo Clave Presupuestal Valido");
				$("#institNominaID").focus();
			}
		}
	});

	$('#convenioID').change(function(){
		consultaClaveConvenio();
	});

	$('#formaGenerica').validate({
		rules : {
			institNominaID: {
				required: true
			},
			convenioID: {
				required: true
			},
		},

		messages : {
			institNominaID: {
				required: 'Especifique de la Empresa de Nómina'
			},
			convenioID: {
				required: 'Especifique el Convenio de Nómina'
			},
		}
	});

    $('#buscar').keyup(function(){
    	buscar = document.getElementById("buscar").value;
    	if(buscar.trim().length > 2){
    		buscarGridClavePresup($("#buscar").val().trim());
    	}
    	if(buscar.trim().length == 0){
    		buscarGridClavePresup($("#buscar").val().trim());
    	}
    });

});

	function exitoTransParametro(){
		consultaGridClavePresup();
		$("#institNominaID").val($("#consecutivo").val());
		$("#descripcion").val("");
		$("#convenioID").val("");
		$("#buscar").val("");
		$("#clavesPresupuestales").val("");
		clavesPresupuestales = [];
		$("#institNominaID").focus();
		deshabilitaBoton('graba', 'submit');
		deshabilitaBoton('elimina', 'submit');
		$('#gridClavePresupConv').html("");
		$('#gridClavePresupConv').show();
		$(".blockUI").css({top: "0px"});
		$("#mensaje").css({top: "100px", left: "5px", width:"250px", position:'absolute'});
	}

	function falloTransParametro(){

	}

	function consultaInstitucionNomina() {
		var numInstitucion  = $("#institNominaID").val();
		var numcon = 1;
		var institNominaBean = {
			'institNominaID': numInstitucion
		};

		if(numInstitucion > 0 && numInstitucion != '' && !isNaN(numInstitucion) ){
			institucionNomServicio.consulta(numcon,institNominaBean,function(institucionNomina) {
				if(institucionNomina!=null){
					if(institucionNomina.estatus == 'A'){
						$('#descripcion').val(institucionNomina.nombreInstit);
						consulConvenioNominaCombo();
						habilitaBoton('graba', 'submit');
						deshabilitaBoton('elimina', 'submit');
					}else{
						mensajeSis("La Empresa de Nómina se Encuentra Cancelada");
						$('#institNominaID').focus();
						$('#descripcion').val(institucionNomina.nombreInstit);
						consulConvenioNominaCombo();
						deshabilitaBoton('graba', 'submit');
						deshabilitaBoton('elimina', 'submit');
					}
				}else{
					mensajeSis("El Número de Empresa de Nómina No Existe");
					$("#institNominaID").val("");
					$("#descripcion").val("");
					$('#institNominaID').focus();
					deshabilitaBoton('graba', 'submit');
					deshabilitaBoton('elimina', 'submit');
				}
			});
		}
	}

	function consultaGridClavePresup(){
		var params = { };
		params['tipoLista'] = 3;

		$.post("clavePresupuestalesGridVista.htm", params, function(data){
			if(data.length > 0) {
				$('#gridClavePresup').html(data);
				$('#gridClavePresup').show();
				agregaFormatoControles('gridClavePresup');
			}else{
				$('#gridClavePresup').html("");
				$('#gridClavePresup').show();
			}

		});
	}

	function buscarGridClavePresup(valor){
		var params = { };
		params['tipoLista'] = 3;
		params['buscar'] = valor;
		params['page'] = "buscar";

		$.post("clavePresupuestalesGridVista.htm", params, function(data){
			if(data.length > 0) {
				$('#gridClavePresup').html(data);
				$('#gridClavePresup').show();
				agregaFormatoControles('gridClavePresup');
				seleccionarCheck();
			}else{
				$('#gridClavePresup').html("");
				$('#gridClavePresup').show();
			}

		});
	}

	function consultaGridClavePresupConv(){
		var params = { };
		params['tipoLista'] = 1;
		params['institNominaID'] =  $("#institNominaID").val();

		$.post("clavePresupConvGridVista.htm", params, function(data){
			if(data.length > 0) {
				$('#gridClavePresupConv').html(data);
				$('#gridClavePresupConv').show();
				agregaFormatoControles('gridClavePresupConv');
			}else{
				$('#gridClavePresupConv').html("");
				$('#gridClavePresupConv').show();
			}
		});
	}

	/* ============= CONSULTA DE LOS CONVENIO DE NOMINA ============ */
	function consulConvenioNominaCombo(){
		var tipoLis =2;
		var bean = {
			'institNominaID' :  $("#institNominaID").val()
		};

		dwr.util.removeAllOptions('convenioID');
		dwr.util.addOptions('convenioID', {'':'SELECCIONE'});
		conveniosNominaServicio.lista(tipoLis,bean, function(convenio){
			if(convenio.length > 0){
				dwr.util.addOptions('convenioID', {'0':'TODOS'});
				dwr.util.addOptions('convenioID', convenio, 'convenioNominaID', 'descripcion');
			}
		});
	}

	function estableceClavePresup(control) {
		var numero = control.substr(8,control.length);

		var jqIdAsignado = eval("'nomClavePresupID" + numero+ "'");
		var clavePresupID = document.getElementById(jqIdAsignado).value;
		var clavesPresup = $('#clavesPresupuestales').val();
		if (clavesPresup != ""){
			clavesPresupuestales = clavesPresup.split(",");
		}

		if( $("#" + control ).is(":checked") ){
			clavesPresupuestales.push(clavePresupID);
			$('#clavesPresupuestales').val(clavesPresupuestales.toString());
		}else{
			var indice = clavesPresupuestales.indexOf(clavePresupID); // obtenemos el indice
			clavesPresupuestales.splice(indice, 1); // 1 es la cantidad de elemento a eliminar
			$('#clavesPresupuestales').val(clavesPresupuestales.toString());
		}
	}

	function consultaClaveConvenio() {
		var numInstitucion  = $("#institNominaID").val();
		var convenioID  = $("#convenioID").val();
		var numcon = 1;
		var convenioBean = {
			'institNominaID': numInstitucion,
			'convenioID' : convenioID
		};

		if(convenioID != '' && !isNaN(convenioID) ){
			clavePresupConvenioServicio.consulta(numcon,convenioBean,function(claveConvenio) {
				if(claveConvenio != null){
					$("#nomClaveConvenioID").val(claveConvenio.nomClaveConvenioID);
					$("#convenioID").val(claveConvenio.convenioID);
					$('#clavesPresupuestales').val(claveConvenio.nomClavePresupID);
					seleccionarCheck();
					habilitaBoton('elimina', 'submit');
				}else{
					$("#nomClaveConvenioID").val(0);
					$('#clavesPresupuestales').val("");

					var numCodig = $('#numero').val();
					for(var i = 1; i <= numCodig; i++){
						var jqIdReqClave = eval("'reqClave" + i+ "'");
						$('#'+jqIdReqClave).attr('checked',false);
					}
					deshabilitaBoton('elimina', 'submit');
				}
			});
		}
	}

	function seleccionarCheck(){
		var numCodig = $('#numero').val();
		var clavesPresupuestales = $('#clavesPresupuestales').val();
		var clavePresup = clavesPresupuestales.split(',');
		var tamanio = clavePresup.length;
		for (var j=0;j<tamanio;j++) {
			var clavePresupID = clavePresup[j];

			for(var i = 1; i <= numCodig; i++){
				var jqIdNomClavePresupID = eval("'nomClavePresupID" + i+ "'");
				var nomClavePresupID = document.getElementById(jqIdNomClavePresupID).value;
				var jqIdReqClave = eval("'reqClave" + i+ "'");

				if( !$("#" + jqIdReqClave ).is(":checked") ){
					if(nomClavePresupID == clavePresupID){
						$('#'+jqIdReqClave).attr('checked',true);
					}else{
						$('#'+jqIdReqClave).attr('checked',false);
					}
				}
			}
		}
	}

	/* ============= CONSULTA DE LAS CLAVES PRESUPUESTALES ============ */
	function consulClavePresupCombo(){
		var numCodig = $('#numeroClavConv').val();
		var tipoCon=2;

		for(var i = 1; i <= numCodig; i++){
			var  jqIdNomClaveConvenioID = eval("'clavePresupConvenioID" + i+ "'");
			var  nomClaveConvenioID = document.getElementById(jqIdNomClaveConvenioID).value;

			var  jqIdNomClavePresupID = eval("'clavePresupID" + i+ "'");

			var bean = {
				'nomClaveConvenioID' : nomClaveConvenioID
			};

			dwr.util.removeAllOptions(jqIdNomClavePresupID);
			clavePresupConvenioServicio.lista(tipoCon,bean, { async: false,callback: function(clavesPresup){
				dwr.util.addOptions(jqIdNomClavePresupID, clavesPresup, 'nomClavePresupID', 'descripcion');
			}});
		}
	}

	function seleccionarTodos(){
		var numCodig = $('#numero').val();
		clavesPresupuestales = [];

		var clavesPresup = $('#clavesPresupuestales').val();
		if (clavesPresup != ""){
			clavesPresupuestales = clavesPresup.split(",");
		}
		if($("#selecionarTodo" ).is(":checked") ){
			for(var i = 1; i <= numCodig; i++){
				var jqIdAsignado = eval("'nomClavePresupID" + i + "'");
				var clavePresupID = document.getElementById(jqIdAsignado).value;
				var jqIdReqClave = eval("'reqClave" + i+ "'");

				if( !$("#" + jqIdReqClave ).is(":checked") ){
					$('#'+jqIdReqClave).attr('checked',true);
					clavesPresupuestales.push(clavePresupID);
					$('#clavesPresupuestales').val(clavesPresupuestales.toString());
				}
			}
		}else{
			for(var i = 1; i <= numCodig; i++){
				var jqIdReqClave = eval("'reqClave" + i+ "'");
				var jqIdAsignado = eval("'nomClavePresupID" + i + "'");
				var clavePresupID = document.getElementById(jqIdAsignado).value;
				var indice = clavesPresupuestales.indexOf(clavePresupID); // obtenemos el indice
				clavesPresupuestales.splice(indice, 1); // 1 es la cantidad de elemento a eliminar

				$('#'+jqIdReqClave).attr('checked',false);
				$('#clavesPresupuestales').val(clavesPresupuestales.toString());
			}
		}
	}
