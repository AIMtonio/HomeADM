$(document).ready(function(){
	
	var parametroBean = consultaParametrosSession();
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$(':text').focus(function() {
		esTab = false; 
	});
	var catTipoCategoriaCon ={
		'principal'	: 1
	};
	var catTipoConSegto = {
		'principal'		: 1,
		'foranea'		: 2,
		'gestores'		: 10,
		'supervisores'	: 11
	};
	var catTipoTranSegto = {
  		'agrega'	: 1,
  		'modifica'	: 2,
  		'elimina'	: 3
	};

	var catLisSegto = {
		'principal'		: 1,
		'foranea'		: 2,
		'gestores'		: 3,
		'supervisores'  : 4
	};
	
	var tran=0;
	//-----------------------Métodovalidas y manejo de eventos-----------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('eliminar','submit');
	deshabilitaControl('estatusProg');
	deshabilitaControl('fechaRegistro');
	$('#segtoPrograID').focus();
	
   $.validator.setDefaults({
   	submitHandler: function(event) {
   		habilitaControl('estatusProg');
   		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','segtoPrograID','funcionExito','funcionFallo');
		}
	});

   //seguimiento manual
   $('#fechaRegistro').val(parametroBean.fechaAplicacion);
   
   $('#segtoPrograID').bind('keyup',function(e){
	   if(this.value.length >= 2){
		   var camposLista = new Array(); 
		   var parametrosLista = new Array();
		   camposLista[0] = "puestoResponsableID"; 
		   camposLista[1] = "nombreResponsable";
			parametrosLista[0] = parametroBean.numeroUsuario;
		   parametrosLista[1] = $('#segtoPrograID').val();
		   listaAlfanumerica('segtoPrograID', '1', '2', camposLista, parametrosLista, 'listaCalSegto.htm');
	   }
   });
   
   $('#segtoPrograID').blur(function() {
	   validaSeguiManual(this.id);
   });
   
   $('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', '9', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
		$('#grupoID').val('');
		$('#nombreGrupo').val('');
	});
   
   $('#creditoID').blur(function() {
		esTab=true;
	   validaCredito();
	});
   
   $('#grupoID').blur(function() {
		esTab=true;
 		validaGrupo();
	});
   
   $('#grupoID').bind('keyup',function(e){
	   if(this.value.length >= 2){ 
		   var camposLista = new Array(); 
		   var parametrosLista = new Array(); 
		   camposLista[0] = "nombreGrupo";
		   parametrosLista[0] = $('#grupoID').val();
		   listaAlfanumerica('grupoID', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm'); 
		   $('#creditoID').val('');
		   $('#nombreCompleto').val('');
	   } 
   });
   
   $('#fechaProg').change(function() { 
		var fechaelegida = $('#fechaProg').val(); 
		var fechaAplicacion = parametroBean.fechaAplicacion;
		$('#fechaProg').focus();
 		if(esFechaValida(fechaelegida)){
 			if(fechaelegida<fechaAplicacion){
 				alert("La Fecha Elegida no debe ser menor que la del Sistema");
 				$('#fechaProg').val(fechaAplicacion);
 				$('#fechaProg').focus();
 				
 			}else{
				$('#fechaProg').focus();
			}
 		}
	});
   
   $('#puestoResponsableID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "ejecutorID";
			parametrosLista[0] = $('#puestoResponsableID').val();
			camposLista[1] = "categoriaID";
			parametrosLista[1] = $('#categoriaID').val();
			listaAlfanumerica('puestoResponsableID', '2', catLisSegto.gestores, camposLista, parametrosLista,'listaSeguimiento.htm');
		}
	});

   $('#puestoResponsableID').blur(function() {
		consultaResponsable(this.id);
		consultaSupervisor(this.id);
	});
   
   $('#esForzado').attr('checked',true);	
	
   $('#grabar').click(function(){
		$('#tipoTransaccion').val(catTipoTranSegto.agrega);
		tran=1;
	});
   
   $('#modificar').click(function(){
		$('#tipoTransaccion').val(catTipoTranSegto.modifica);
		tran=2;
	});
   
   $('#eliminar').click(function(){
		$('#tipoTransaccion').val(catTipoTranSegto.elimina);
		tran=3;
	});
       
   $("#horaProgramada").setMask('time').val('hh:mm');
   
   $("#horaProgramada").blur(function(){
	   validaHora();   
   });
   
   //-----------------------------------------
   
	$('#seguimientoID').bind('keyup',function(e) {
		lista('seguimientoID', '1', '2', 'nombre', $('#seguimientoID').val(),'listaSeguimiento.htm');
	});

	$('#seguimientoID').blur(function(){
		validaSeguimiento(this.id);
	});
	
	$('#categoriaID').bind('keyup',function(e) { 		
		lista('categoriaID', '1', '1', 'categoriaID', $('#categoriaID').val(),'listaSegtoCategoria.htm');
	});

	$('#categoriaID').blur(function(){
		validaCategoria(this.id);
	});
	
	$('#ejecutorID').bind('keyup',function(e) {
		listaAlfanumerica('ejecutorID', '1', '1','descripcion', $('#ejecutorID').val(),'listaPuestos.htm');
	});
	
	$('#ejecutorID').blur(function() {
  		consultaPuesto(this.id);
	});
	
	$('#supervisorID').bind('keyup',function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#supervisorID').val();
			listaAlfanumerica('supervisorID', '1', '1',camposLista, parametrosLista,'listaPuestos.htm');
		}
	});
	
	$('#supervisorID').blur(function() {
  		consultaPuesto(this.id);
	});
	
	$('#producCreditoID').bind('keyup',function(e){  
		lista('producCreditoID', '1', '1', 'descripcion', $('#producCreditoID').val(), 'listaProductosCredito.htm');
	});

	$('#producCreditoID').blur(function() {
		consultaProducCredito(this.id);
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {			
			seguimientoID: {
				required: true,
				numeroPositivo: true
			},
			fechaProgramada:{
				required: true,
			},
			categoriaID:{
				required: true,
			},
			puestoResponsableID:{
				required: true,
			},
			puestoSupervisorID:{
				required: true,
			},
			fechaRegistro:{
				required: true,
			},
			horaProgramada:{
				required:true
			}
		},		
		messages: {
			campaniaID: {
				required: 'Especifique Número de Seguimiento',
				numeroPositivo: 'Sólo números positivos',
			},
			fechaProgramada:{
				required: 'Especifique Fecha Programada',
			},
			categoriaID:{
				required: 'Especifique Categoría',
			},
			puestoResponsableID:{
				required: 'Especifique Gestor',
			},
			puestoSupervisorID:{
				required: 'Especifique Supervisor',
			},
			fechaRegistro:{
				required: 'Especifique Fecha Forzado',
			},
			horaProgramada:{
				required: 'Especifique la Hora Programada'
			}
		}
	});
	
	//-------------Validaciones de controles---------------------
	function validaSeguiManual(control) {
		var numSeg = $('#segtoPrograID').val();
		var segtoBeanCon = {
  			'segtoPrograID'		: numSeg,
  			'puestoResponsableID': parametroBean.numeroUsuario
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSeg != '' && !isNaN(numSeg) && esTab){
			if(numSeg=='0'){
				habilitaBoton('grabar', 'submit');
				inicializaForma('formaGenerica','segtoPrograID');
				deshabilitaBoton('modificar', 'submit');
				$('#montoSolicitado').val('');
				$('#montoAutorizado').val('');
				$('#puestoSupervisorID').val('');
				$('#nombreSupervisor').val('');
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
			} else {
				deshabilitaBoton('grabar', 'submit');
				segtoManualServicio.consulta(1, segtoBeanCon,function(segto) {
						if(segto!=null){
              //----------------------------------------------------------------
							estatusSeg = segto.estatus;													
							$('#segtoPrograID').val(segto.segtoPrograID);
							if(segto.creditoID=='0'){
							}else{
							 $('#creditoID').val(segto.creditoID);	
							 esTab=true;
							 validaCredito();
							}
							if(segto.grupoID=='0'){
							}else{
							 $('#grupoID').val(segto.grupoID);
							 esTab=true;
							 validaGrupo();
							}
							$('#fechaProg').val(segto.fechaProgramada);
							$('#horaProgramada').val(segto.horaProgramada);
							$('#categoriaID').val(segto.categoriaID);
							validaCat();
							$('#puestoResponsableID').val(segto.puestoResponsableID);
							validaResp();
							$('#puestoSupervisorID').val(segto.puestoSupervisorID);
							validaSuper();
							if(segto.tipoGeneracion=='M'){
			                    $('#tipoGeneracion').val('M').selected = true;
		                  	}
			               	else{
		                    	$('#tipoGeneracion').val('A').selected = true;
		                  	  	}
							if(segto.esForzado=='S'){
			                    $('#segtoForzado').attr("checked",true) ;
		                  	}
			               	else{
		                    	$('#segtoForzado').attr("checked",false) ;
		                  	  	}
							if(segto.estatus=='P'){
			                    $('#estatusProg').val('P').selected = true;
		                  	}else if(segto.estatus=='I'){
		                    	$('#estatusProg').val('I').selected = true;
		                  	  	}else if(segto.estatus=='T'){
		                    	$('#estatusProg').val('T').selected = true;
		                  	  	}else if(segto.estatus=='C'){
		                    	$('#estatusProg').val('C').selected = true;
		                  	  	}else if(segto.estatus=='R'){
		                    	$('#estatusProg').val('R').selected = true;
		                  	  	}else if(segto.estatus=='A'){
		                    	$('#estatusProg').val('A').selected = true;
		                  	  	}
								$('#fechaRegistro').val(segto.fechaRegistro);
								if(estatusSeg != 'P'){
									deshabilitaBoton('modificar', 'submit');
									deshabilitaBoton('eliminar', 'submit');
								}else{
									habilitaBoton('modificar', 'submit');
									habilitaBoton('eliminar', 'submit');									
								}
								$('#fechaProg').focus();
								deshabilitaBoton('agregar', 'submit');
							if(segto.fechaProgramada < parametroBean.fechaSucursal ){
							  //alert("La Fecha Programada es menor a la Fecha del Sistema");
							  //$('#segtoPrograID').focus();
							  deshabilitaControl('creditoID');
							  deshabilitaControl('grupoID');
							  deshabilitaControl('fechaProg');
							  deshabilitaControl('horaProgramada');
							  deshabilitaControl('categoriaID');
							  deshabilitaControl('descCategoria');
							  deshabilitaControl('puestoResponsableID');
							  deshabilitaBoton('modificar', 'submit');
						 	}else{
					 		  habilitaControl('creditoID');
							  habilitaControl('grupoID');
							  habilitaControl('fechaProg');
							  habilitaControl('horaProgramada');
							  habilitaControl('categoriaID');
							  habilitaControl('descCategoria'); 
							  habilitaControl('puestoResponsableID');							
							  if(estatusSeg != 'P'){
									deshabilitaBoton('modificar', 'submit');
									deshabilitaBoton('eliminar', 'submit');
								}else{
									habilitaBoton('modificar', 'submit');
									habilitaBoton('eliminar', 'submit');									
								}
						 	}
				//--------------------------------------------------------------			
						}
						else{
							alert("El Número de Seguimiento No Existe");
							inicializaForma('formaGenerica','segtoPrograID');
							$('#montoSolicitado').val('');
							$('#montoAutorizado').val('');
							$('#puestoSupervisorID').val('');
							$('#nombreSupervisor').val('');
							deshabilitaBoton('modificar', 'submit');
   						deshabilitaBoton('agregar', 'submit');
							$('#segtoPrograID').focus();
							$('#segtoPrograID').val('');
						}
				});
				
			}
		}
	}
	
	function validaGrupo() {
		var numGrupo = $('#grupoID').val();
		var grupoID=$('#grupoID').asNumber();
		setTimeout("$('#cajaLista').hide();", 200);
		var principal = 1;
		esTab=true;
		if(numGrupo != '' && !isNaN(numGrupo) && esTab){
			if(numGrupo=='0'){
				alert("No existe el Grupo");
				$('#grupoID').focus();
				$('#grupoID').focus();
				$('#grupoID').val('');
				$('#nombreGrupo').val('');
				limpiaGeneralesCredito();
			} else {
				var grupoBeanCon = {
  				'grupoID':$('#grupoID').val(),
				};
				gruposCreditoServicio.consulta(principal,grupoBeanCon,function(grupos) {
						if(grupos!=null){
							$('#nombreGrupo').val(grupos.nombreGrupo);
							consultaSolGrupo(grupos.grupoID);
						}else{
							alert("No Existe el grupo");
							deshabilitaBoton('grabar', 'submit');
							$('#grupoID').focus();
							$('#grupoID').val('');
							$('#nombreGrupo').val('');
							limpiaGeneralesCredito();
						}
				});
			}
		}
	}
	
	function validaCredito() {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		var porCredito = 3;
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			if(numCredito=='0'){
				alert("No existe el Crédito");
				$('#creditoID').focus();
				$('#creditoID').focus();
				$('#creditoID').val('');
				$('#nombreCompleto').val('');
				limpiaGeneralesCredito();
			} else {
				
				var segtoBeanCon = { 
  				'creditoID':numCredito
				};
				
				segtoManualServicio.consulta(porCredito,segtoBeanCon,function(segto) {
						if(segto!=null){
							$('#nombreCompleto').val(segto.nombreCliente);
							$('#solicitudCreditoID').val(segto.solCred);
							$('#producCredID').val(segto.prodCred);
							$('#nombreProdCred ').val(segto.descripcion);
							$('#montoSolicitado').val(segto.montoSoli);
							$('#montoSolicitado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							$('#montoAutorizado').val(segto.montoAutor);
							$('#montoAutorizado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							if (segto.fechaSol == '1900-01-01'){
								$('#fechaSol').val('');
							}else {
								$('#fechaSol').val(segto.fechaSol);
							}
							
							$('#fechaDesembolso').val(segto.fechaDesem);
							$('#estatusCre').val(segto.estatusCred);
							$('#saldoVigente').val(segto.saldoCapVig);
							$('#saldoVigente').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							$('#diasAtraso').val(segto.diasFaltaPago);
							$('#saldoAtrasado').val(segto.saldoCapAtrasa);
							$('#saldoAtrasado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							$('#saldoVencido').val(segto.saldoCapVencido);
							$('#saldoVencido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							$('#grupoID').val('');
							$('#nombreGrupo').val('');
						}
						else{
							alert("No Existe Generales del Crédito");
							$('#creditoID').focus();
							$('#creditoID').val('');
							$('#nombreCompleto').val('');	
							limpiaGeneralesCredito();
						}
				});			
			}							
		}
	}
	
	function consultaSolGrupo(numGrupo){
		var numGrupoBean  = numGrupo;
		var conPorGrupo  = 4;
		var SegtoBeanCon = {
			'grupoID': numGrupoBean
		};
		esTab=true;
		if(numGrupoBean != '' && !isNaN(numGrupoBean) && esTab){
			segtoManualServicio.consulta(conPorGrupo,SegtoBeanCon,function(segto) {
				if(segto != null){
					$('#solicitudCreditoID').val(segto.solCred);
					$('#producCredID').val(segto.prodCred);
					$('#nombreProdCred ').val(segto.descripcion);
					$('#montoSolicitado').val(segto.montoSoli);
					$('#montoSolicitado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#montoAutorizado').val(segto.montoAutor);
					$('#montoAutorizado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#fechaSol').val(segto.fechaSol);
					$('#fechaDesembolso').val(segto.fechaDesem);
					$('#estatusCre').val(segto.estatusCred);
					$('#saldoVigente').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#diasAtraso').val(segto.diasFaltaPago);
					$('#saldoAtrasado').val(segto.saldoCapAtrasa);
					$('#saldoAtrasado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#saldoVencido').val(segto.saldoCapVencido);
					$('#saldoVencido').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			 		$('#creditoID').val('');
			 		$('#nombreCompleto').val('');
				}
				else{
					alert("No Existe Generales del Crédito");
					deshabilitaBoton('grabar', 'submit');
					$('#grupoID').focus();
					$('#grupoID').val();
					$('#nombreGrupo').val('');						
				}
			});
		}		
	}

	function consultaResponsable(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();
		var categoriaID = $('#categoriaID').val();
		var usuarioBeanCon = {
				'ejecutorID': numUsuario,
				'categoriaID'	: categoriaID 
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) ){
			seguimientoServicio.consulta(catTipoConSegto.gestores,usuarioBeanCon,function(usuario) {
				if(usuario!=null){
					$('#nombreResponsable').val(usuario.nombreUsuario);
				}else{ 
					alert("El Usuario Seleccionado no es Gestor");
					$('#puestoResponsableID').val('');
					$('#puestoResponsableID').focus();
					$('#nombreResponsable').val('');
					$('#puestoSupervisorID').val('');
					$('#nombreSupervisor').val('');
				}    						
			});
		}

	}
	function validaResp() {
		var numUsuario = $('#puestoResponsableID').val();;
		var foranea=2;
		var usuarioBeanCon = {  
				'usuarioID':numUsuario 
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario)  ){
			usuarioServicio.consulta(foranea,usuarioBeanCon,function(usuario) {  
				if(usuario!=null){
					$('#puestoResponsableID').val(usuario.usuarioID);
					$('#nombreResponsable').val(usuario.nombreCompleto);
				}  						
			});
		}
	}
	function consultaSupervisor(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();
		var categoriaID = $('#categoriaID').val();
		var usuarioBeanCon = {
				'ejecutorID': numUsuario,
				'categoriaID'	: categoriaID 
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numUsuario != '' && !isNaN(numUsuario) ){
			seguimientoServicio.consulta(catTipoConSegto.supervisores,usuarioBeanCon,function(usuario) {
				if(usuario!=null){
					$('#puestoSupervisorID').val(usuario.supervisorID);
					$('#nombreSupervisor').val(usuario.nombreUsuario);
					
				}  						
			});
		}
	}
	
	function validaSuper() {
		var numUsuario = $('#puestoSupervisorID').val();;
		var foranea=2;
		var usuarioBeanCon = {  
				'usuarioID':numUsuario 
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario)  ){
			usuarioServicio.consulta(foranea,usuarioBeanCon,function(usuario) {  
				if(usuario!=null){
					$('#puestoSupervisorID').val(usuario.usuarioID);
					$('#nombreSupervisor').val(usuario.nombreCompleto);
				}
			});
		}
	}
	function validaCategoria(idControl){
		var jqCatego  = eval("'#" + idControl + "'");
		var categoID = $(jqCatego).val();
		var CategoBeanCon = {
			'categoriaID': categoID
		};
		if(categoID != '' && !isNaN(categoID) && esTab){
			catSegtoCategoriasServicio.consulta(catTipoCategoriaCon.principal,CategoBeanCon,function(categorias) {
				if(categorias != null){
					$('#descCategoria').val(categorias.descripcion);
				}else{
					alert("El Número de Categoria No Existe");
					$(jqCatego).focus();
					$('#categoriaID').val('');
					$('#descCategoria').val('');
				}
			});
		}
	}
	function validaCat(){
		var categoID  = $('#categoriaID').val();
		var CategoBeanCon = {
			'categoriaID': categoID
		};
		if(categoID != '' && !isNaN(categoID) && esTab){
			catSegtoCategoriasServicio.consulta(catTipoCategoriaCon.principal,CategoBeanCon,function(categorias) {
				if(categorias != null){
					$('#descCategoria').val(categorias.descripcion);
				}
			});
		}
	}
	
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de Fecha no Válida (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				alert("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea");
				return false;
			}
			return true;
		}
	}
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	
	function validaHora(){
		var x= $("#horaProgramada").val();
		   var y= x.substr(0,2);
		   if(y>=25){
			   $("#horaProgramada").focus();
			   $("#horaProgramada").val('');
			   alert("La Hora no es Correcta");
		   }
	}
	
	//---------------------------------------------------
	function validaSeguimiento(idControl){
		var jqSegto  = eval("'#" + idControl + "'");
		var segtoID = $(jqSegto).val();
		var SegtoBeanCon = {
				'seguimientoID': segtoID
		};
		if(segtoID != '' && !isNaN(segtoID) && esTab){
			if(segtoID == 0){
				$('#estatus').val('VIGENTE');
				habilitaBoton('grabar', 'submit');
			}
		}
	}
});

var estatusSeg = '';


function limpiaGeneralesCredito (){
	$('#solicitudCreditoID').val('');
	$('#producCredID').val('');
	$('#nombreProdCred').val('');
	$('#montoSolicitado').val('');
	$('#montoAutorizado').val('');
	$('#fechaSol').val('');
	$('#fechaDesembolso').val('');
	$('#estatusCre').val('');
	$('#saldoVigente').val('');
	$('#diasAtraso').val('');
	$('#saldoAtrasado').val('');
	$('#saldoVencido').val('');
}
function funcionExito(){		
	if(estatusSeg != 'P'){
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('eliminar', 'submit');
	}else{
		habilitaBoton('modificar', 'submit');
		habilitaBoton('eliminar', 'submit');									
	}
    deshabilitaBoton('grabar', 'submit');
	deshabilitaControl('estatusProg');
	agregaFormatoControles('formaGenerica');
	$('#creditoID').val('');
	$('#grupoID').val('');
	$('#nombreGrupo').val('');
	$('#nombreCompleto').val('');
	$('#solicitudCreditoID').val('');
	$('#producCredID').val('');
	$('#nombreProdCred').val('');
	$('#montoSolicitado').val('');
	$('#montoAutorizado').val('');
	$('#fechaSol').val('');
	$('#fechaDesembolso').val('');
	$('#estatusCre').val('');
	$('#saldoVigente').val('');
	$('#diasAtraso').val('');
	$('#saldoAtrasado').val('');
	$('#saldoVencido').val('');
	$('#fechaProg').val('');
	$('#horaProgramada').val('');
	$('#categoriaID').val('');
	$('#categoriaID').val('');
	$('#descCategoria').val('');
	$('#puestoResponsableID').val('');
	$('#nombreResponsable').val('');
	$('#puestoSupervisorID').val('');
	$('#nombreSupervisor').val('');
	$('#segtoForzado').attr('checked',false);
	$('#fechaRegistro').val('');
	$('#tipoGeneracion').val('');
	$('#estatusProg').val('');
}
function funcionFallo(){
	
}