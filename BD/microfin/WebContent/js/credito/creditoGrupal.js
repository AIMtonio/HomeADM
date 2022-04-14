$(document).ready(function() {
		esTab = true;
//Definicion de Constantes y Enums
	
	var catTipoConCreditoGrup = {
  		'principal'	:1,
  		'foranea'	:2
  		};
	
	
	var catTipoTranCreditoGrup = {
  		'altaGrupal':13
  		};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('agregar', 'submit');
   $('#grupoID').focus();

	agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {
	 	esTab = false;
	});

	$.validator.setDefaults({
      submitHandler: function(event) {
      	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID','ExitoGrabar','ErrorGrabar');
      }
   });

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agregar').click(function() {	
		$('#tipoTransaccion').val(catTipoTranCreditoGrup.altaGrupal);
		$('#tipoActualizacion').val(catTipoTranCreditoGrup.altaGrupal);	
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
		 listaAlfanumerica('grupoID', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm'); }
	 });
	
	var parametroBean = consultaParametrosSession();	
	 $('#sucursalID').val(parametroBean.sucursal);
	 
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			grupoID: 'required'
				
		},
		
		messages: {
			grupoID: 'Especifique numero de Grupo'
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	function validaGrupo(idControl){
		var jqGrupo  = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();	 
		
		var grupoBeanCon = { 
  		'grupoID':grupo
		};	
		setTimeout("$('#cajaLista').hide();", 200);
		inicializaForma('formaGenerica','grupoID' );
		if(grupo != '' && !isNaN(grupo) && esTab){
			gruposCreditoServicio.consulta(catTipoConCreditoGrup.principal,grupoBeanCon,function(grupos) {
			if(grupos!=null){
				esTab=true;   
				
				if(grupos.estatusCiclo != 'C' ){
					deshabilitaBoton('agregar', 'submit');	
					mensajeSis("El Ciclo debe estar Cerrado");
				}else {
						habilitaBoton('agregar', 'submit');						
					}
				$('#nombreGrupo').val(grupos.nombreGrupo);						
				consultaIntegrantesGrid();
				$('#cicloActual').val(grupos.cicloActual);
			}else{ 
				mensajeSis("El Grupo no Existe");
				$(jqGrupo).focus();
				deshabilitaBoton('agregar', 'submit');							
				}
			});		
		}
   }
			


	
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =1;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
						if(cliente!=null){							
							$('#nombreCliente').val(cliente.nombreCompleto);	
							
						}else{
							mensajeSis("No Existe el Cliente");
							$(jqCliente).focus();
						}    						
				});
			}
	}
	
	function consultaSolicitudesGrupo() { 
		var numReg = $('input[name=consecutivoID]').length;
		if(numReg <1){
			deshabilitaBoton('agregar', 'submit');	
		}
		for(var i = 1; i <= numReg; i++){
			var solicitud = "solicitudCre"+i;	
			esTab= true;
			consultaSolicitudCred(solicitud);
		}
	}
	
	

	
});


	function consultaIntegrantesGrid(){
		$('#Integrantes').val('');
		var params = {};		
	
		params['tipoLista'] = 2;
		params['grupoID'] = $('#grupoID').val();
			
			
		$.post("integrantesGpoCreditoGridVista.htm", params, function(data){
			if(data.length >0) {
				var fecIn = $('#fechaInicio').val(); 
				$('#Integrantes').html(data); 
				$('#Integrantes').show();
				agregaFormatoControles('Integrantes');
				var fechaRegis = $('#fecRegistro').val();
				$('#fechaRegistro').val(fechaRegis);
				var productCred = $('#productoCreditoID').val();
				$('#producCreditoID').val(productCred);
				consultaProducCredito('producCreditoID');	
				consultaSolicitudesGrupo();
				consultaCtaPrincipal();
			}else{
				$('#Integrantes').html("");
				$('#Integrantes').show();
			}
		});
		
	}
	
	function consultaCtaPrincipal(){
		var cuentaPal = 9;
		var grupo = $('#grupoID').val();
		var grupoBeanCon = {
  			'grupoID' : grupo
		};
		$('#lisCtes').val('');
		if(grupo != '' && !isNaN(grupo) && esTab){
			integraGruposServicio.listaConsulta(cuentaPal,grupoBeanCon,function(grupos) {
				for (var i = 0; i < grupos.length; i++){
					if(grupos[i].estatus != 'Activo'){
						$('#lisCtes').val($('#lisCtes').val() + '\n - '+ grupos[i].clienteID );
					}
				}
				if ($('#lisCtes').val() != ""){
					mensajeSis("El (Los) siguiente(s) cliente(s) no tiene(n) una cuenta principal: " + $('#lisCtes').val());
					deshabilitaBoton('agregar', 'submit');
				}			
			});
		}
	}
	

function consultaFechaVencimiento(idFecIn,idPlazo){
		var jqPlazo  = eval("'#" + idPlazo + "'");
		var plazo = $(jqPlazo).val();	
		var jqFecIni = eval("'#" + idFecIn + "'");
		var fechInicio = $(jqFecIni).val();	
		
		var tipoCon=3;

		var PlazoBeanCon = { 
		'plazoID' :plazo, 
		'fechaActual' : fechInicio
		};
				plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos) { 
					if(plazos!=null){ 
					$(jqPlazo).val(plazos.fechaActual);
					}
				});	
	}
	
		function consultaSolicitudesGrupo() { 
		var numReg = $('input[name=consecutivoID]').length;
		if(numReg <1){
			deshabilitaBoton('agregar', 'submit');	
		}
		for(var i = 1; i <= numReg; i++){
			var solicitud = "solicitudCre"+i;	
			esTab= true;
			consultaSolicitudCred(solicitud);
		}
	}	
	
		

function consultaProducCredito(idControl) {  
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();			
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		var linea =$('#lineaCreditoID').val();
		var tipoConsulta=2;

			if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
				productosCreditoServicio.consulta(tipoConsulta,ProdCredBeanCon,function(prodCred) {
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

function consultaSolicitudCred(idControl) {
		var jqSolCred = eval("'#" + idControl + "'");
		var numSolicitud = $(jqSolCred).val();
		var tipCon = 1;
		
		var SolicitudBeanCon = {
  				'solicitudCreditoID':numSolicitud,
				};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSolicitud != '' && !isNaN(numSolicitud) && esTab){
			solicitudCredServicio.consulta(tipCon,SolicitudBeanCon,function(solicitudCred) {
						if(solicitudCred!=null){
							if(solicitudCred.creditoID != 0){

								deshabilitaBoton('agregar', 'submit');
							}
							var status = solicitudCred.estatus;
							if(status == 'I'){
								mensajeSis("La Solicitud no ha sido Autorizada");
								deshabilitaBoton('agregar', 'submit');
							}						
						} else{
								deshabilitaBoton('agrega', 'submit');
								mensajeSis("No Existe la solicitud");
									$('#grupoID').focus();
							}
					});
			}
	}
		
		
function ExitoGrabar(){
	deshabilitaBoton('agregar','submit');
	consultaIntegrantesGrid();
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('Integrantes');
}

function ErrorGrabar(){
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('Integrantes');
	deshabilitaBoton('agregar','submit');
}