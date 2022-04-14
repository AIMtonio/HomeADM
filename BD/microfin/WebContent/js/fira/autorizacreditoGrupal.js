$(document).ready(function() {
	//Definicion de Constantes y Enums
	var catTipoTranCreditoGrup = {
  		'autorizaGrupal':14,
  		'autorizaGrupalAgro':37,
  		'actPrincipal':1,
  		'actPrincipalAgro':3,
  		'documentosEnt':1

  		};

	var catTipoOperCreditoGrup = {
	  		'autoriza':1,
	  		'documentosEnt':2
	  		};


	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('autorizar', 'submit');
   deshabilitaBoton('grabar', 'submit');
   deshabilitaBoton('expediente', 'submit');

	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('listaGarantias');
    $('#grupoID').focus();

	$.validator.setDefaults({
      submitHandler: function(event) {
   	      grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','grupoID','exitoPantallaAutCreditoGr','falloPantallaAutCreditoGr');

      }
   });


	$('#autorizar').click(function() {
		$('#tipoTransaccion').val(catTipoTranCreditoGrup.autorizaGrupalAgro);
		$('#tipoActualizacion').val(catTipoTranCreditoGrup.actPrincipalAgro);
		$('#tipoOperacion').val(catTipoOperCreditoGrup.autoriza);
	});


	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTranCreditoGrup.autorizaGrupal);
		$('#tipoActualizacion').val(catTipoTranCreditoGrup.actPrincipal);
		var grupo = $('#grupoID').val();
		$('#creditoID').val(grupo);
		$('#tipoOperacion').val(catTipoOperCreditoGrup.documentosEnt);
		guardarGriDocumentos();

	});


	$('#expediente').click(function() {
		consultaTipodocumento('numCredito');
	});


	$('#grupoID').blur(function() {
		validaGrupo(this.id);
	});


	 $('#grupoID').bind('keyup',function(e){
		 if(this.value.length >= 2){
			var camposLista = new Array();
		    var parametrosLista = new Array();
		    	camposLista[0] = "nombreGrupo";
		    	parametrosLista[0] = $('#grupoID').val();
		 listaAlfanumerica('grupoID', '1', '5', camposLista, parametrosLista, 'listaGruposCredito.htm'); }

	 });



	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			grupoID: 'required'
		},

		messages: {
			grupoID: 'Especifique numero de Grupo'
		}
	});





	// se construye la cadena de datos del grid a guargar
	function guardarGriDocumentos(){
 		var mandar = verificarva();

 		if(mandar!=1){
			var numDocEnt = consultaFilas();//$('input[name=consecutivo]').length;

			$('#datosGridDocEnt').val("");
			for(var i = 1; i <= numDocEnt; i++){
				if(i == 1){
					$('#datosGridDocEnt').val($('#datosGridDocEnt').val() +
					document.getElementById("creditoID"+i+"").value + ']' +
					document.getElementById("clasificaTipDocID"+i+"").value + ']' +
					document.getElementById("docAceptado"+i+"").value + ']' +
					document.getElementById("tipoDocumentoID"+i+"").value + ']' +
					document.getElementById("comentarios"+i+"").value);
				}else{
					$('#datosGridDocEnt').val($('#datosGridDocEnt').val() + '[' +
					document.getElementById("creditoID"+i+"").value + ']' +
					document.getElementById("clasificaTipDocID"+i+"").value + ']' +
					document.getElementById("docAceptado"+i+"").value + ']' +
					document.getElementById("tipoDocumentoID"+i+"").value + ']' +
					document.getElementById("comentarios"+i+"").value);
				}
			}

		}
		else{
			mensajeSis("Faltan Datos");
			event.preventDefault();
		}
	}

// verificamos que no existan campos vacios en el grid de documentos
	function verificarva(){
		quitaFormatoControles('documentosEnt');
		var numDoc = consultaFilas();

		$('#datosGridDocEnt').val("");
		for(var i = 1; i <= numDoc; i++){
 			var idDocAcep = document.getElementById("docAceptado"+i+"").value;

 			if (idDocAcep ==""){
 				document.getElementById("docAceptado"+i+"").focus();
				$(idDocAcep).addClass("error");
 				return 1;
 			}

			var idcde = document.getElementById("comentarios"+i+"").value;
 			if (idcde ==""){
 				if(idDocAcep =="" || idDocAcep =="S"){
 					document.getElementById("comentarios"+i+"").focus();
 	 				$(idcde).addClass("error");
 	 					return 1;
 				}

 				if(idDocAcep =="N"){
 					 $('#comentarios'+i).val('X');//document.getElementById("comentarios"+i+"").value == 'X';
 				}



 			}

		}
	}
	function consultaTipodocumento(idControl) {
		var ConsulCantDoc = 1;
		var jqCredito  = eval("'#" + idControl + "'");
		var credito = $(jqCredito).val();

		var creditoBeanCon = {
			'creditoID'	:credito
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(credito != '' && !isNaN(credito )){
			creditoArchivoServicio.consulta(ConsulCantDoc,creditoBeanCon,function(credito) {
				if(credito!=null){
					Par_TipoDocumento= credito.numeroDocumentos;
						if(Par_TipoDocumento ==0 || Par_TipoDocumento==null ){
								mensajeSis("No hay documentos digitalizados");
							}else{
								if($('#numCredito').val()==null || $('#numCredito').val()==''){
									mensajeSis("Especifique Número de Crédito");
									//$('#numCredito').focus();
									}

									else{
										var creditoID = $('#numCredito').val();

										var usuario = 	parametroBean.nombreUsuario;
										var nombreInstitucion =  parametroBean.nombreInstitucion;
										var fechaEmision = parametroBean.fechaSucursal;
										var pagina='creditoArchivoPDF.htm?creditoID='+creditoID+'&clienteID='+$('#clieID').val()+
										'&nombreCliente='+$('#nombreClie').val()+'&estatus='+$('#statusCre').val()+
										'&productoCreditoID='+$('#producCreditoID').val()+'&nombreProducto='+$('#nombreProducto').val()+'&grupoID='+$('#grupoID').val()+
										'&nombreGrupo='+ $('#nombreGrupo').val()+'&ciclo='+$('#cicloActual').val()+'&cuentaID='+$('#cuenta').val()+'&descripcionCta='+$('#decripcioncta').val()
										+'&nombreusuario='+usuario+'&nombreInstitucion='+nombreInstitucion+'&parFechaEmision='+fechaEmision;
										window.open(pagina, '_blank');
										}
									}
								}
					else{
							mensajeSis("No hay documentos digitalizados");


						}
				});
			}
		}

});//fin
var catTipoConCreditoGrup = {
  		'principal':1,
  		'foranea':2,
  		};


//------------ Validaciones de Controles -------------------------------------
function validaGrupo(idControl){
	var jqGrupo  = eval("'#" + idControl + "'");
	var grupo = $(jqGrupo).val();

	var grupoBeanCon = {
		'grupoID':grupo
	};
	setTimeout("$('#cajaLista').hide();", 200);
	//inicializaForma('formaGenerica','grupoID' );
	if(grupo != '' && !isNaN(grupo)){
		gruposCreditoServicio.consulta(15,grupoBeanCon,function(grupos) {
		if(grupos!=null){

			$('#nombreGrupo').val(grupos.nombreGrupo);
			if(grupos.estatusCiclo != 'C' ){
				mensajeSis("El Ciclo debe estar Cerrado");
				deshabilitaBoton('autorizar', 'submit');
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('expediente', 'submit');
				 $('#listaGarantias').hide();
			     $('#documentosEnt').hide();
			     $('#fieldsetDocEnt').hide();
				$('#Integrantes').hide();
				$(jqGrupo).focus();
				limpiaForm($('#formaGenerica'));
			}else{
				consultaIntegrantesGrid();

			  $('#listaGarantias').hide();
		      $('#documentosEnt').hide();
		      $('#fieldsetDocEnt').hide();
		      $('#cicloActual').val(grupos.cicloActual);
			}


		}else{
			mensajeSis("El Grupo no Existe");
			$(jqGrupo).focus();
			//ocultar el grid de documentos y el de asigna y botones

			 $('#listaGarantias').hide();
		     $('#documentosEnt').hide();
		     $('#fieldsetDocEnt').hide();
		     $('#Integrantes').hide();
		     $('#divComentarios').hide();

			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('autorizar', 'submit');
			limpiaForm($('#formaGenerica'));

			}
		});
	}

}

// funciones para el exito o error de la pantalla
function exitoPantallaAutCreditoGr() {
	if($('#tipoOperacion').val()==1){
		deshabilitaBoton('autorizar', 'submit');
		deshabilitaBoton('grabar', 'submit');
		 $('#listaGarantias').hide();
	     $('#documentosEnt').hide();
	     $('#fieldsetDocEnt').hide();
	     $('#divComentarios').hide();

	}else{

		consultaIntegrantesGrid();
		$('#listaGarantias').hide();
	    $('#documentosEnt').hide();
	    $('#fieldsetDocEnt').hide();
	    $('#divComentarios').hide();

	}
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('Integrantes');

  }



  function falloPantallaAutCreditoGr() {
  //	agregaFormatoControles('formaGenerica');
	//agregaFormatoControles('Integrantes');
  }

  function consultaIntegrantesGrid(){
		$('#Integrantes').val('');
		var params = {};

		params['tipoLista'] = 5;
		params['grupoID'] = $('#grupoID').val();

		$.post("integrantesGpoAutorCredGridVista.htm", params, function(data){

			if(data.length >0) {
				$('#Integrantes').html(data);
				$('#Integrantes').show();
				var productCred = $('#productoCreditoID').val();
				$('#producCreditoID').val(productCred);
				consultaProducCredito('producCreditoID');
				consultaCreditosGrupo();
					var ver = habilitaBotonAutorizar();//document.getElementById("ver").value;
					if(ver==0){
						habilitaBoton('autorizar', 'submit');
					}else{
						deshabilitaBoton('autorizar', 'submit');
					}
				realizarchecked();
			}else{
				$('#Integrantes').html("");
				$('#Integrantes').show();
			}
		});
	}


	function consultaProducCredito(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();
		var ProdCredBeanCon = {
			'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(ProdCred != '' && !isNaN(ProdCred)){
			productosCreditoServicio.consulta(catTipoConCreditoGrup.foranea,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#nombreProducto').val(prodCred.descripcion);

				}else{
					mensajeSis("No Existe el Producto de Crédito");
					$('#producCreditoID').focus();
					$('#producCreditoID').select();
				}
			});
		}
	}

	function consultaCreditosGrupo() {
		var numReg = $('input[name=consecutivoID]').length;
		if(numReg <1){
			deshabilitaBoton('autorizar', 'submit');
			}
		for(var i = 1; i <= numReg; i++){
			var credito = "solicitudCre"+i;
			consultaCredito(credito);
			var idMonto = "monto"+i;
			var jqMonto  = eval("'#" + idMonto + "'");
			$(jqMonto).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		}
	}


	function consultaCredito(idControl) {
		var jqCredito  = eval("'#" + idControl + "'");
		var credito = $(jqCredito).val();
		var creditoBeanCon = {
			'creditoID'	:credito
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(credito != '' && !isNaN(credito) ){
			creditosServicio.consulta(catTipoConCreditoGrup.principal, creditoBeanCon,function(creditos) {
					if(creditos!=null){
						var inactivo='I';
						if(creditos.estatus !=inactivo){
							deshabilitaBoton('autorizar', 'submit');
						}/*else{
							habilitaBoton('autorizar', 'submit');
							}*/
						if(creditos.numTransacSim == '0'){
							mensajeSis("No hay amortizaciones para este Crédito");
							}
					}else{
						mensajeSis("El Crédito no Existe");
						$(jqCredito).focus();
						deshabilitaBoton('autorizar', 'submit');
						$(jqCredito).select();
						$('#Integrantes').hide();
						$('#documentosEnt').hide();
					}
			});

		}
	}

	function consultaCta(idControl) {
		idControl = eval("'#"+idControl+"'");
		var numCta = $(idControl).val();
        var conCta = 3;
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clieID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if(numCta != '' && !isNaN(numCta)){
        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
        		if(cuenta!=null){
        			consultaTipoCta(cuenta.tipoCuentaID);

        		}else{
        			$('#decripcioncta').val("");
        		}
        	});
        }
	}

	function consultaTipoCta(idControl) {
		var numTipoCta = idControl;
		var conTipoCta=2;
		var TipoCuentaBeanCon = {
  			'tipoCuentaID':numTipoCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCta != '' && !isNaN(numTipoCta)){
			tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
				if(tipoCuenta!=null){
					$('#decripcioncta').val(tipoCuenta.descripcion);
				}else{
					$('#decripcioncta').val("");
				}
			});
		}
	}

//----------------grid de integrantes de grupo----------
function busca(control){
	var numero= control.substr(10,control.length);
	var credID = eval("'solicitudCre" + numero+ "'");
	var clienteID = eval("'clienteID" + numero+ "'");
	var nombreClieID = eval("'nombre" + numero+ "'");
	var estatusID = eval("'estatus" + numero+ "'");
	var numcuentaID = eval("'cuentaID" + numero+ "'");


	var valorCredito= document.getElementById(credID).value;
	var valorCliente= document.getElementById(clienteID).value;
	var valorNombreClie= document.getElementById(nombreClieID).value;
	var valorEstatus= document.getElementById(estatusID).value;
	var valorNumCuenta= document.getElementById(numcuentaID).value;

	if($('#'+control).attr('checked')==true ){

		$('#numCredito').val(valorCredito);
		$('#clieID').val(valorCliente);
		$('#nombreClie').val(valorNombreClie);
		$('#cuenta').val(valorNumCuenta);

		consultaCta('cuenta');


		if(valorEstatus=='I'){
			$('#statusCre').val('INACTIVO');

		}
		if(valorEstatus=='A'){
			$('#statusCre').val('AUTORIZADO');

		}
		if(valorEstatus=='V'){
			$('#statusCre').val('VIGENTE');

		}
		if(valorEstatus=='P'){
			$('#statusCre').val('PAGADO');

		}
		if(valorEstatus=='C'){
			$('#statusCre').val('CANCELADO');

		}
		if(valorEstatus=='B'){
			$('#statusCre').val('VENCIDO');

		}
		if(valorEstatus=='K'){
			$('#statusCre').val('CASTIGADO');

		}

		habilitaBoton('expediente', 'submit');
		 consultaGridDocEnt(valorCredito);
		 consultaListaGarantias(valorCredito);



	}
}
// Verifica  los campos de Visualizar del grid de Integrantes
function visualizarGridDocumentos(){
	var verGrid = 0;
	$('input[name=visualizar]').each(function() {
		var jqIdVisualizar =  eval("'#"+ this.id +"'");
		if($(jqIdVisualizar).attr('checked')==true ){
			verGrid ++;
		}
	});

	return verGrid;
}

// Consulta el campo de docCompleta del grid de Integrantes del credito
function habilitaBotonAutorizar(){
	var contador=0;
	$('input[name=docCompleta]').each(function() {
		var jqIdcredCheckComp =  eval("'#"+ this.id +"'");
		var noCompleta='N';
		 var valor = $(jqIdcredCheckComp).val();
		if(valor==noCompleta){
			contador++;
		}
	});
	return contador;
}


//grid de asignacion de garantias
function consultaListaGarantias(creditoID){
	agregaFormatoControles('listaGarantias');
	$('#listaGarantias').val('');
	var params = {};
	params['tipoLista'] = 1;
	params['solicitudCreditoID'] = 0;
	params['creditoID'] = creditoID;

	$.post("garantiasListaGridVista.htm", params, function(data){
		if(data.length >0) {
			$('#listaGarantias').html(data);
			$('#listaGarantias').show();

			if($('#numeroDetalle').val() == 0){
				$('#listaGarantias').html("");
				$('#listaGarantias').hide();
			}

			//consultaPropietarioGarantia();

		}else{
			$('#listaGarantias').html("");
			$('#listaGarantias').hide();
		}


	});


}


//Consulta grid de documentos entregados
function consultaGridDocEnt(creditoID){

	$('#datosGridDocEnt').val('');
	var params = {};
	params['tipoLista'] = 1;
	params['creditoID'] = creditoID;


	$.post("creditoDocEntGridVista.htm", params, function(data){
		if(data.length >0) {

			$('#documentosEnt').html(data);
			$('#documentosEnt').show();
			$('#fieldsetDocEnt').show();

			var habilitaBotonGrabar=visualizarGridDocumentos();

			if(habilitaBotonGrabar!=0){
				habilitaBoton('grabar', 'submit');
			}else{
				deshabilitaBoton('grabar', 'submit');
			}
			if($('#statusCre').val()!='INACTIVO'){
				deshabilitaBoton('grabar', 'submit');

				var numFilas=consultaFilas();
				for(var i = 1; i <= numFilas; i++){
					var jqIdComentario = eval("'comentarios" + i+ "'");
					deshabilitaControl(jqIdComentario);
				}
			}
			$("#numeroDocumento").val(consultaFilas());
			hasChecked();
		}else{
			$('#documentosEnt').html("");
			$('#documentosEnt').hide();
			$('#fieldsetDocEnt').hide();
		}
	});
}

//Al dar clic en el campo docEntregados del grid de documentos cambia su valor a 'S'

function realiza(control){
	var si='S';
	var no ='N';
	if($('#'+control).attr('checked')==true){
	document.getElementById(control).value = si;
	}else{
		document.getElementById(control).value = no;
 }

}

// consulta cuantas filas tiene el grid de documentos
function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;

	});
	return totales;
}

//al cargar el grid de documentos verifica cuales tienen valo 'S' y los selecciona
function hasChecked(){
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var jqIdChecked = eval("'documentoAcep" + numero+ "'");

		var valorChecked= document.getElementById(jqIdChecked).value;
		var aceptado='S';
		if(valorChecked==aceptado){
			$('#docAceptado'+numero).attr('checked','true');

		}else{
			$('#docAceptado'+numero).attr('checked',false);
		}
	});

}
//al cargar el grid de Integrantes recorrer las filas y si el valor es 'S' seleccionar
function realizarchecked(){
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdCredChe = eval("'credCheckComp" + numero+ "'");

		var valorCre= document.getElementById(jqIdCredChe).value;
		if(valorCre=='S'){
			$('#docCompleta'+numero).attr('checked',true);
		}else{
			$('#docCompleta'+numero).attr('checked',false);
		}
	});

}
