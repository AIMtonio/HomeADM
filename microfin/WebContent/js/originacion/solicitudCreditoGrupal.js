//este archivo es usado por solicitudCreditoGrupal.jsp
var siRequiereCalculoRatios='S';
var siRequiereReferencias='S';
$(document).ready(function() {
	$('#grupo').focus();
	
	var noAceptado = 0;

		esTab = true;
		solicitudActual="";
	//Definicion de Constantes y Enums  
	var catTipoConCreditoGrup = {
  		'principal':1,
  		'foranea':2,	
  		};	
	
	var catTipoTranCreditoGrup = {
  		'altaGrupal':13,
  		'actualiza':3
  		};
	
	var catTipoActCreditoGrup = {
	  		 'rechazar':4,
	  		'liberar':6,
	  		'agregaComentario':7
	  };
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
   deshabilitaBoton('agregar', 'submit');
	agregaFormatoControles('formaMenu');
	$('#calculaRatios').hide('slow');
	$("#referenciasSolicitud").hide();
	$('#ratios').html("");	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$( '#tabs' ).tabs({
		ajaxOptions: {
			error: function( xhr, status, index, anchor ) {
				$( anchor.hash ).html("Couldn't load this tab. We'll try to fix this as soon as possible. " +
					"If this wouldn't be a demo." );
			}
		}
    });				

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	
	
	$.validator.setDefaults({
			submitHandler: function(event) {
						grabaFormaTransaccion(event, 'formaMenu', 'contenedorForma', 'mensaje','true','grupo');	
			}
				
	});	
	
	$('#liberarGrupal').click(function() {
			if(muestraErrorValidaGrupal()){
				return false;
			}
			$('#tipoTransaccion').val(catTipoTranCreditoGrup.actualiza);
			$('#tipoActualizacion').val(catTipoActCreditoGrup.liberar);
	});
	
	$('#cancelar').click(function() {
		
		
		var motivoRechazo=''; 
		
		var comentarioEjec = $('#nuevosComents').val();
		var comentario = $.trim(comentarioEjec);
		if(comentario==''){
			motivoRechazo = prompt("Favor de agregar el motivo del rechazo.");
			
			if(motivoRechazo != null){
				var motivoR = $.trim(motivoRechazo);
				motivoR = motivoR.toUpperCase();
				$('#motivoRechazo').val(motivoR);
			
			}else{
				return false;
			}	
			
		}else{
			motivoRechazo = confirm('Esta seguro que este es el motivo del rechazo: "'+comentario+'"');
			
			if(motivoRechazo == true){
			
			$('#motivoRechazo').val(comentario);
			
			}else{
				return false;
			}	
		}
		 
		$('#tipoTransaccion').val(catTipoTranCreditoGrup.actualiza);
		$('#tipoActualizacion').val(catTipoActCreditoGrup.rechazar);
		setTimeout("refrescaIntegrantesGrid();", 300);
	});
	
	$('#agregarComent').click(function() {
		
		var comentarioEjec = $('#nuevosComents').val();
		var comentario = $.trim(comentarioEjec);
		if(comentario==''){
			mensajeSis("Agregue un comentario");
			return false;
		}
		
		$('#tipoTransaccion').val(catTipoTranCreditoGrup.actualiza);
		$('#tipoActualizacion').val(catTipoActCreditoGrup.agregaComentario);
		setTimeout("refrescaIntegrantesGrid();", 300);
		
	});
	
		
	$('#grupo').blur(function() { 
		validaGrupo(this.id);
	});
	
	$('#solic').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#obligado").attr("href", "#contObligados");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$("#check").attr("href" , "#checklist");
		
		
		$('#burocredito').html("");	
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#contObligados').html("");
		$('#asignaAval').html("");	
		$('#asignaObligados').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 		
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaSolicitudCredito();
		}
		$(this).removeAttr("href");
	});

	$('#bc').click(function() {

		$("#grup").attr("href= '#grupos'");
		$("#solic").attr("href", "#solicitud");
		$("#datSosEc").attr("href","#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#obligado").attr("href", "#contObligados");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#garan").attr("href" , "#garantias");		
		$("#asigGaran").attr("href", "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$("#check").attr("href" , "#checklist");		
		$('#solicitud').html(""); 
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#contObligados').html("");
		$('#asignaAval').html("");	
		$('#asignaObligados').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaBC() ;
		}
		$(this).removeAttr("href");
	});
	
	$('#check').click(function() {

		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#obligado").attr("href", "#contObligados");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		
		$('#solicitud').html(""); 
		$('#burocredito').html("");
		$('#contAvales').html("");	
		$('#contObligados').html("");
		$('#asignaAval').html("");	
		$('#asignaObligados').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaCheckList();
		}
		$(this).removeAttr("href");
	});

	
	$('#aval').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#obligado").attr("href", "#contObligados");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$("#check").attr("href" , "#checklist");		
		
		$('#solicitud').html(""); 
		$('#burocredito').html("");
		$('#checklist').html("");		
		$('#contObligados').html("");
		$('#asignaAval').html("");	
		$('#asignaObligados').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaAvales(); 
		}
		$(this).removeAttr("href");		
	});
	
	$('#obligado').click(function() {

		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		
		$('#solicitud').html(""); 
		$('#burocredito').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");	
		$('#asignaObligados').html("");	
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaObligados(); 
		}
		$(this).removeAttr("href");
	});
	
	$('#asigAval').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#obligado").attr("href", "#contObligados");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$("#check").attr("href" , "#checklist");
		
		$('#solicitud').html(""); 
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#contObligados').html("");
		$('#asignaObligados').html("");
		$('#garantias').html("");				
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){ 
			consultaAsignaAvales(); 
		}
		
		
		$(this).removeAttr("href");			
	});
	
	$('#asigObligado').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#obligado").attr("href", "#contObligados");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$("#check").attr("href" , "#checklist");
		
		$('#solicitud').html(""); 
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#contObligados').html("");
		$('#asignaAval').html("");	
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaAsignaObligados();   
		}
		$(this).removeAttr("href");
		
	});
	
	$('#garan').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#obligado").attr("href", "#contObligados");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$("#check").attr("href" , "#checklist");
		
		$('#solicitud').html(""); 
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#contObligados').html("");
		$('#asignaAval').html("");	
		$('#asignaObligados').html("");
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaGarantias();  
		}
		$(this).removeAttr("href");
		
	});
	

	$('#asigGaran').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#obligado").attr("href", "#contObligados");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#garan").attr("href", "#garantias");	
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$("#check").attr("href" , "#checklist");
		
		$('#solicitud').html(""); 
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#contObligados').html("");
		$('#asignaAval').html("");	
		$('#asignaObligados').html("");	
		$('#garantias').html("");		
		$('#dtsSocioEcon').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaAsignaGarantias();
		}
		$(this).removeAttr("href");

	});
	
	$('#datSosEc').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#aval").attr("href", "#contAvales");
		$("#obligado").attr("href", "#contObligados");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$("#check").attr("href" , "#checklist");
		$('#solicitud').html(""); 
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#contObligados').html("");
		$('#asignaAval').html("");	
		$('#asignaObligados').html("");	
		$('#garantias').html("");	
		$('#asignaGarantias').html("");
		$('#ratios').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaDtsSocioEc();
		}
		$(this).removeAttr("href");		
	});
	
	$('#grup').click(function() {
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#obligado").attr("href", "#contObligados");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$("#check").attr("href" , "#checklist");
		$('#solicitud').html(""); 
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#contObligados').html("");
		$('#asignaAval').html("");	
		$('#asignaObligados').html("");	
		$('#garantias').html("");	
		$('#asignaGarantias').html(""); 
		$('#dtsSocioEcon').html(""); 
		$('#ratios').html("");
		$('#referenciasSol').html("");
		esTab=true; 
	});
	
	$('#calculaRatios').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#aval").attr("href", "#contAvales");
		$("#obligado").attr("href", "#contObligados");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#referenciasSolicitud").attr("href" , "#referenciasSol");
		$("#check").attr("href" , "#checklist");
		$('#solicitud').html(""); 
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#contObligados').html("");
		$('#asignaAval').html("");	
		$('#asignaObligados').html("");	
		$('#garantias').html("");	
		$('#asignaGarantias').html("");
		$('#referenciasSol').html("");
		if ($(this).attr("href") != undefined ){  
			consultaRatios();
		}
		$(this).removeAttr("href");		
	});
	
	$('#referenciasSolicitud').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#aval").attr("href", "#contAvales");
		$("#obligado").attr("href", "#contObligados");
		$("#asigAval").attr("href" ,"#asignaAval");
		$("#asigObligado").attr("href" ,"#asignaObligados");
		$("#garan").attr("href", "#garantias");		
		$("#asigGaran").attr("href" , "#asignaGarantias");
		$("#calculaRatios").attr("href" , "#ratios");
		$("#check").attr("href" , "#checklist");
		$('#solicitud').html(""); 
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");	
		$('#contObligados').html("");
		$('#asignaAval').html("");	
		$('#asignaObligados').html("");	
		$('#garantias').html("");	
		$('#asignaGarantias').html("");
		if ($(this).attr("href") != undefined ){  
			consultaReferencias();
		}
		$(this).removeAttr("href");		
	});
	
	 $('#grupo').bind('keyup',function(e){
		 if(this.value.length >= 2){ 
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
		    	camposLista[0] = "nombreGrupo";
		    	parametrosLista[0] = $('#grupo').val();
		 listaContenedor('grupo', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm'); }
	 });
	

		$('#formaMenu').validate({
			rules: {
				grupo: { 
					required: true
				}		 


			},

			messages: {
				grupo: {
					required: 'Seleccione un Grupo'
				} 
				 
			}		
		});
	
	//------------ Validaciones de Controles -------------------------------------

	function validaGrupo(idControl){
		var jqGrupo  = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();	 
		
		var grupoBeanCon = { 
  		'grupoID':grupo
		};	
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		inicializaForma('formaMenu','grupo' );
		$('#Integrantes').html("");
		if(grupo != '' && !isNaN(grupo) && esTab){
			$('#nombreGrupo').val("");
			$('#cicloActual').val("");
			gruposCreditoServicio.consulta(catTipoConCreditoGrup.principal,grupoBeanCon,function(grupos) {
			if(grupos!=null){
				esTab=true;  
				solicitudActual="";
				$('#numSolicitud').val("");
				
				$('#nombreGrupo').val(grupos.nombreGrupo);	
				$('#fechaRegistro').val(grupos.fechaRegistro);						
				consultaIntegrantesGrid();
				var nombEstatus="";
				switch(grupos.estatusCiclo){
					case 'N': nombEstatus="NO INICIADO";
							   $('#puedeAgregarSolicitudes').val('S');
					break;
					case 'A': nombEstatus="ABIERTO"; 
							   $('#puedeAgregarSolicitudes').val('S');
					break;
					case 'C': 
							nombEstatus="CERRADO"; 
							$('#puedeAgregarSolicitudes').val('N');					
					break;
				}
				$('#nombreEstatusCiclo').val(nombEstatus);
				$('#cicloActual').val(grupos.cicloActual);
				$('#calculaRatios').hide('slow');
				$('#ratios').html("");	
				
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
		setTimeout("$('#cajaListaContenedor').hide();", 200);		
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
	

	function consultaSolicitudCredito(){
		$('#solicitud').load("catalogoSolicitudCredito.htm");
	}	
	
	function consultaBC(){
		$('#burocredito').load("consultaSolicitudBCVista.htm");
	}
	
	function consultaAvales(){
		$('#contAvales').load("avalesCatalogo.htm");
	}
	
	function consultaObligados(){	
		$('#contObligados').load("obligadosSolidariosCatalogo.htm");
	}
	
	function consultaAsignaAvales(){
		$('#asignaAval').load("avalesPorSolicitud.htm");
	}
	
	function consultaAsignaObligados(){
		$('#asignaObligados').load("obligadosSolidSoliciCatalogoVista.htm");
	}
	
	function consultaGarantias(){
		$('#garantias').load("registroGarantia.htm");
	}

	function consultaAsignaGarantias(){
		$('#asignaGarantias').load("asignacionGarantia.htm");
	}
	
	function consultaCheckList(){
		$('#checklist').load("solicitudCheckList.htm");
	}
	
	function consultaDtsSocioEc(){
		$('#dtsSocioEcon').load("altaDatosSocioeconomicos.htm");
	}
	function consultaRatios(){
		$('#ratios').load("generacionRatios.htm");
	}
	function consultaReferencias(){
		$('#referenciasSol').load("referenciaCliente.htm");
	}
}); // fin funcion principal


	

function consultaProducCredito(idControl) {  
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();			
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		var linea =$('#lineaCreditoID').val();
		var conPrincipal= 1;

			if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
				productosCreditoServicio.consulta(conPrincipal,ProdCredBeanCon,function(prodCred) {
					if(prodCred!=null){
						$('#nombreProducto').val(prodCred.descripcion);
						validaProductoRequiereReferencias(prodCred.requiereReferencias);
						validaProductoRequiereCheckList(prodCred.requiereCheckList);
						validaProductoRequiereObligados(prodCred.requiereObligadosSolidarios);
						if(prodCred.calculoRatios == siRequiereCalculoRatios){
							$('#calculaRatios').show('slow');
							
						}else{
							$('#calculaRatios').hide('slow');
							$('#ratios').html("");	
						}
					}else{							
						mensajeSis("No Existe el Producto de Crédito");
						$('#producCreditoID').focus();
						$('#producCreditoID').select();																					
					}
				});
			}				 					
	}


	//funcion solo para consultar cada que cambia el grupo
	function consultaIntegrantesGrid(){
		$('#Integrantes').val('');
		var params = {};		
	
		params['tipoLista'] = 4;
		params['grupoID'] = $('#grupo').val();
			
			
		$.post("integrantesGpoCreditoGridVista.htm", params,function(data){
			
			if(data.length >0) { 
				var fecIn = $('#fechaInicio').val(); 
				$('#Integrantes').html(data);
				$('#Integrantes').show();
				agregaFormatoControles('Integrantes');
				var fechaRegis = $('#fecRegistro').val();
				if(fechaRegis !=""){
					$('#fechaRegistro').val(fechaRegis);	
				}
				var productCred = $('#prodCreditoID').val();
				validaDatosGrupalesG(productCred,$('#grupo').val());
				validaLiberarGrupal(Number(productCred),Number( $('#grupo').val()));
				$('#productoCredito').val(productCred);
				
				
				consultaProducCredito('productoCredito');	
				solicitudActual = $('#numSolicitud').val();
				
				if($('#1').val()=='S'){
					solicitudActual= $('#radioSolicitud1').val();
				}
				validaCheckSolicitud();
				validarRadioSeleccionado();
			}else{
				$('#Integrantes').html("");
				$('#Integrantes').show();
			}

		}); 
	}
	
 
	//funcion solo para refrescar cada que  se agrega un mensaje
	function refrescaIntegrantesGrid(){
		$('#Integrantes').val('');
		var params = {};		
	
		params['tipoLista'] = 4;
		params['grupoID'] = $('#grupo').val();
			
			
		$.post("integrantesGpoCreditoGridVista.htm", params, function(data){
			
			if(data.length >0) { 
				var fecIn = $('#fechaInicio').val(); 
				$('#Integrantes').html(data); 
				$('#Integrantes').show();
				
				///aqui se guardan los valores datos de extado civil y sexp

				
				agregaFormatoControles('Integrantes');
				var fechaRegis = $('#fecRegistro').val();
				if(fechaRegis !=""){
					$('#fechaRegistro').val(fechaRegis);	
				}
				var productCred = $('#prodCreditoID').val();
				$('#productoCredito').val(productCred);
				validaDatosGrupalesG(productCred,$('#grupo').val());
				consultaProducCredito('productoCredito');	
				solicitudActual = $('#numSolicitud').val();
				validaCheckSolicitud();
				validarRadioSeleccionado();
			}else{
				$('#Integrantes').html("");
				$('#Integrantes').show();
			}			
		}); 
	}


	
	// funcion llamada en el onclick de el radio buton del grid de integrantes del grupo
	function validarRadio(númeroFila){ 
		
		$('input[name=radioSeleccionado]').each(function() {
			var jqRadio = eval("'#" + this.id + "'");   
				if ( $(jqRadio).val()=='S' ){ 
					$(jqRadio).val('N');
				}
			});	
		
				var jqRadioSelecionado = eval("'#" + númeroFila + "'");   
				var jqsolic = eval("'#radioSolicitud" + númeroFila + "'"); 
				var jqProspecto = eval("'#prospecto" + númeroFila + "'"); 
				var jqCliente = eval("'#cliente" + númeroFila + "'"); 
				var jqRequiereGarant = eval("'#requiereGarantia" + númeroFila + "'"); 
				var jqComntEjecutivo = eval("'#comentarioEjecutivo" + númeroFila + "'"); 
				var jqNuevosComentarios =  eval("'#nuevosComentarios" + númeroFila + "'");
				var jqEstatusSolicitud =  eval("'#estatusSolicitud" + númeroFila + "'"); 
				var jqRequiereAvales =  eval("'#requiereAvales" + númeroFila + "'");
				//var jqRequiereReferencias=  eval("'#requiereReferencias" + númeroFila + "'");
				var jqMontoSolicitado = eval("'#montoSolici" + númeroFila + "'"); 
				
				var numSol = 	$(jqsolic).val();
				var idProspecto = $(jqProspecto).asNumber();
				var idCliente = $(jqCliente).asNumber();
				var requiereGarantia = $(jqRequiereGarant).val();
				var requiereAvales = $(jqRequiereAvales).val();
				var comentario =  $(jqComntEjecutivo).val();
				var estatusSolici = $(jqEstatusSolicitud).val();
				var montoSolicitado = $(jqMontoSolicitado).asNumber();
				$(jqRadioSelecionado).val('S');
			    clienteActualGrup = idCliente;
				prospectoActualGrup = idProspecto;
				solicitudActual = numSol;
				$('#numSolicitud').val(solicitudActual);
				$('#clientIDGrupal').val(idCliente);
				$('#prospectIDGrupal').val(idProspecto);
				$('#montSolicit').val(montoSolicitado);
				validaProductoRequiereGarantia(requiereGarantia);
				validaProductoRequiereAvales(requiereAvales);
				validaContieneComentario(comentario);
				validaNuevosComentarios(estatusSolici,jqNuevosComentarios);
	} 
	
	function validaNuevosComentarios(estatusSolicitud, jqComentarioNuevo){
		var inactiva = 'I';
		if(estatusSolicitud == inactiva){
			 habilitaBoton('agregarComent', 'submit');
			 $('#nuevosComents').removeAttr('disabled');
		}else{
			deshabilitaBoton('agregarComent', 'submit');
			$('#nuevosComents').attr('disabled',true);
			$('#nuevosComents').val('');
		}
	}
	
	
	function validaProductoRequiereGarantia(requiereGarantia){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereGarantia == siRequiere){
			$('#garan').show('slow');
			$('#asigGaran').show('slow');
		}
		if(requiereGarantia == noRequiere){
			$('#garantias').html("");				
			$('#asignaGarantias').html(""); 
			$('#garan').hide('slow');
			$('#asigGaran').hide('slow');
		}
	}
	
	function validaProductoRequiereAvales(requiereAvales){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereAvales == siRequiere){
			$('#aval').show('slow');
			$('#asigAval').show('slow');
			
		}
		if(requiereAvales == noRequiere){
			$('#contAvales').html("");	
			$('#asignaAval').html("");
			$('#aval').hide('slow');
			$('#asigAval').hide('slow');
		}
	}
	
	function validaProductoRequiereObligados(requiereObligados){
		var siRequiere = 'S';
		var noRequiere = 'N';
		var indistinto = 'I';
		var cadena_vacia = '';
		if(requiereObligados == siRequiere){
			$('#obligado').show('slow');
			$('#asigObligado').show('slow');
			
		}
		if(requiereObligados == indistinto){
			$('#obligado').show('slow');
			$('#asigObligado').show('slow');
			
		}
		if(requiereObligados == noRequiere){
			$('#contObligados').html("");	
			$('#asignaObligados').html("");
			$('#obligado').hide('slow');
			$('#asigObligado').hide('slow');
		}
		if(requiereObligados == cadena_vacia){
			$('#contObligados').html("");	
			$('#asignaObligados').html("");
			$('#obligado').hide('slow');
			$('#asigObligado').hide('slow');
		}
	}
	
	function validaProductoRequiereReferencias(requiereReferencias){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereReferencias == siRequiere){
			$('#referenciasSolicitud').show('slow');			
		}
		if(requiereReferencias == noRequiere){
			$('#referenciasSol').html("");	
			$('#referenciasSolicitud').hide('slow');
		}
	}
	
	
	function validaContieneComentario(comentario){
		var comentarioEjecutivo =  $.trim(comentario);
		if(comentarioEjecutivo !=''){
			$('#comentEjecut').val(comentarioEjecutivo);
			$('#comentDeEjecutivo').show('slow');			
			$('#labelHistorialCom').show('slow');
		}else{
			$('#comentEjecut').val('');
			$('#comentDeEjecutivo').hide('slow');
			$('#labelHistorialCom').hide('slow');
		}
	}
	
	function validarRadioSeleccionado(){ 
		$('input[name=radioSeleccionado]').each(function() {
		var jqRadio = eval("'#" + this.id + "'");   
			if ( $(jqRadio).val()=='S' ){ 
				validarRadio(this.id);
			}
		});		
	} 
	
	function validaProductoRequiereCheckList(requiereCheckList){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereCheckList == siRequiere){
			$('#check').show('slow');			
		}
		if(requiereCheckList == noRequiere){
			$('#checklist').html("");	
			$('#check').hide('slow');
		}
	}
	
	// funcion para validar que cuando se regrese a la pantalla pivote (solicitud credito grupal)
	// se mantenga en seleccion la solicitud actual (esto debido a que cada que se desplaza de pestaña
	// se refresca el grid de integrantes del grupo)
	function validaCheckSolicitud(){	
		var numDeta = $('input[name=consecutivo]').length;
		for(var i = 1; i <= numDeta; i++){
			var jqSolic = eval("'#solicitudCre" +i+ "'");
			var jqRadioSolic = eval("'#radioSolicitud" +i+ "'");
			var jqSoliciSeleccionada = eval("'#" +i+ "'");
			$(jqSoliciSeleccionada).val('N');
			var solicit = $(jqSolic).val();
			if(solicitudActual == solicit){
				$(jqRadioSolic).attr("checked",true);
				$(jqSoliciSeleccionada).val('S');
			}
			
		}		
	}

	 function validaLiberarGrupal(productoCre , grupo){//id control se refiere al dato que esta tomando de el espacio select, input de la forma para procesar la informacion
		 
		 var proCredBean='';	
			var max 	= Number(0);
			var min		= Number(0);
			var maxh	= Number(0);
			var minh	= Number(0);
			var maxm	= Number(0);
			var minm	= Number(0);
			var maxms	= Number(0);
			var minms	= Number(0);
			var numeroi	= Number(0);
			var numeroms= Number(0);
			var numerom	= Number(0);
			var numeroh	= Number(0);
			//primero se consulta el P-credito por el numero de grupo 
			var conGrupo = 8;
			var GrupoBeanCon = {
					'grupoID' : grupo
				};
		//	    		setTimeout("$('#cajaLista').hide();", 200);
			if (grupo != '' && !isNaN(grupo) ) {
				gruposCreditoServicio.consulta(conGrupo, GrupoBeanCon, function(grupo) {
					if(grupo!=null){
						numeroi		= Number(grupo.tInt);
						numeroms	= Number(grupo.tMS);
						numerom		= Number(grupo.tM);
						numeroh		= Number(grupo.tH);
						if(numeroi<=0){
							noAceptado = 2;
						}else{	
							if(productoCre != null){
								if(Number(productoCre)>0){
									proCredBean = {
	    				    				  'producCreditoID':productoCre
	    				    				};
									productosCreditoServicio.consulta(4,	proCredBean, function(procred) {
							    			if(procred != null ){			
							    			max 	= Number(procred.maxIntegrantes);
							    			min		= Number(procred.minIntegrantes);
							    			maxh	= Number(procred.maxHombres);
							    			minh	= Number(procred.minHombres);
							    			maxm	= Number(procred.maxMujeres);
							    			minm	= Number(procred.minMujeres);
							    			maxms	= Number(procred.maxMujeresSol);
							    			minms	= Number(procred.minMujeresSol);
							    			
							    			if(max<numeroi){
							    				noAceptado = 5;
							    			}else{
							    				if(min>numeroi){
	    						    				noAceptado = 6;
	    						    			}else{
	    						    				if(maxms<numeroms){
	    						    					if(maxms==0){
	    						    						noAceptado = 14;
	    						    					}else{
	    						    						noAceptado = 7;
	    						    					}
		    						    				
		    						    			}else{
		    						    				if(minms>numeroms){
			    						    				noAceptado = 8;
			    						    			}else{
			    						    				if(maxm<numerom){
			    						    					if(maxm==0){
			    						    						noAceptado = 15;
			    						    					}else{
			    						    						noAceptado = 9;
			    						    					}
				    						    			}else{
				    						    				if(minm>numerom){
					    						    				
					    						    				noAceptado = 10;
					    						    			}else{
					    						    				if(maxh<numeroh){
					    						    					if(maxh==0){
					    						    						noAceptado = 16;
					    						    					}else{
					    						    						noAceptado = 11;
					    						    					}
						    						    			}else{
						    						    				if(minh>numeroh){
							    						    				noAceptado = 12;
							    						    			}else{
							    						    				if((maxm-minms)< (numerom-numeroms)){
							    						    					if((maxm-minms)==0){
							    						    						noAceptado = 17;
							    						    					}else{
							    						    						noAceptado = 18;
							    						    					}
								    						    			}else{
								    						    				if((maxm-maxms)>(numerom-numeroms)){
									    						    				noAceptado = 0;
									    						    			}else{
									    						    				noAceptado = 13;
									    						    			}
									    						    		}
							    						    			}
							    						    		}
						    									}
					    						    		}
				    						    		}
			    						    		}
		    						    		}
	    						    		}
							    		}
						    		});
								}else{
									noAceptado = 4;
								}
							}else{
								noAceptado = 3;
							}
						}
					}else{
						noAceptado = 1;
					}
				});
				}
		 }
	 function muestraErrorValidaGrupal(){
		 switch(noAceptado){
		 case 1:mensajeSis('El Grupo No Existe');
			 break;
		 case 2:mensajeSis('El Grupo No Tiene Integrantes');
			 break;
		 case 3:mensajeSis('El Grupo No Tiene Integrantes Relacionados');
			 break;
		 case 4:mensajeSis('El Grupo No Tiene Producto de Crédito Relacionado.');
			 break;
		 case 5:mensajeSis('Se ha superado el Número Máximo de Integrantes para el Grupo. Verfique el Producto de Crédito.');
			 break;
		 case 6:mensajeSis('No se ha alcanzado el Número Mínimo de Integrantes para el Grupo.');
			 break;
		 case 7:mensajeSis('Se ha superado el Número Máximo de Mujeres Solteras para el Grupo. Verfique el Producto de Crédito.'); 
			 break;
		 case 8:mensajeSis('No se ha alcanzado el Número Mínimo de Mujeres Solteras para el Grupo.');
			 break;
		 case 9:mensajeSis('Se ha superado el Número Máximo de Mujeres para el Grupo. Verfique el Producto de Crédito.'); 
			 break;
		 case 10:mensajeSis('No se ha alcanzado el Número Mínimo de Mujeres para el Grupo.');
			 break;
		 case 11:mensajeSis('Se ha superado el Número Máximo de Hombres para el Grupo. Verfique el Producto de Crédito.'); 
			 break;
		 case 12:mensajeSis('No se ha alcanzado el Número Mínimo de Hombres para el Grupo.');
		 	break;
		 case 14:mensajeSis('El Producto de Crédito no Admite Mujeres Solteras, verifique las solicitudes de este Grupo.'); 
		 	break;
		 case 15:mensajeSis('El Producto de Crédito no Admite Mujeres, verifique las solicitudes de este Grupo.'); 
		 	break;
		 case 16:mensajeSis('El Producto de Crédito no Admite Hombres, verifique las solicitudes de este Grupo.'); 
		 	break;
		 case 17:mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras, verifique las solicitudes de este Grupo.'); 
		 	break;
		 case 18:mensajeSis('Se ha superado el Número Máximo de Mujeres con Estado Civil Diferente de Solteras para el Grupo, verifique las solicitudes de este Grupo.'); 
		 	break;
		 }
		 if(noAceptado == 0 || noAceptado == 13)
			 return false;
		return true;
	 }
	/////funcion para consultar y validar los datos grupales	y guarda el error     
	 function validaDatosGrupalesG( productoCre , grupo ){//id control se refiere al dato que esta tomando de el espacio select, input de la forma para procesar la informacion
		 
		 if( 	productoCre > 0 ){
	 		//nuevo paso n 1 obtener los datos ya que tenemos grupo y producto de credito de credito
	 		var proCredBean='';	
			var max 	= Number(0);
			var maxh	= Number(0);
			var maxm	= Number(0);
			var maxms	= Number(0);
			var minms	= Number(0);
			var numeroi	= Number(0);
			var numeroms= Number(0);
			var numerom	= Number(0);
			var numeroh	= Number(0);
			var conGrupo = 8;
			proCredBean = {
				  'producCreditoID':productoCre
				};
			productosCreditoServicio.consulta(4,	proCredBean,{async:false , callback: function(procred) {
	    			if(procred != null ){
	    				if(procred.esGrupal == 'S'){

		    				 max 	= Number(procred.maxIntegrantes);
		    				 maxh	= Number(procred.maxHombres);
		    				 maxm	= Number(procred.maxMujeres);
		    				 maxms	= Number(procred.maxMujeresSol);
		    				 minms	= Number(procred.minMujeresSol);
		    				 if(grupo>0){
		    					 var GrupoBeanCon = {
		 	    						'grupoID' : grupo
		 	    					};
		 	    				gruposCreditoServicio.consulta(conGrupo, GrupoBeanCon,{async:false , callback: function(grupo) {
		 	    					if(grupo!=null){
		 	    						numeroi		= Number(grupo.tInt);
		 	    						numeroms	= Number(grupo.tMS);
		 	    						numerom		= Number(grupo.tM);
		 	    						numeroh		= Number(grupo.tH);

		 				    			if(( max < (numeroi+1) && solicitud == 0 ||  max < (numeroi) && solicitud != 0) && max>0){
		 				    				$('#grupo').val(0);
		 				    				$('#nombreGrupo').val('');
		 				    				$('#cicloActual').val('');
		 				    				setTimeout("$('#grupo').focus().select();",0);
		 				    				setTimeout("$('#cajaListaContenedor').hide();", 200);
		 				    				
		 				    				
		 				    				inicializaForma('formaMenu','grupo' );
		 				    				$('#Integrantes').html("");
		 				    				mensajeSis('Se ha superado el Número Máximo de Integrantes para el Grupo. Verfique el Producto de Crédito.');
		 				    			}else{
		 				    				if(maxms<numeroms){
		 				    					$('#grupo').val(0);
		 				    					$('#nombreGrupo').val('');
			 				    				$('#cicloActual').val('');
			 				    				
		 				    					setTimeout("$('#grupo').focus().select();",0);
		 				    					setTimeout("$('#cajaListaContenedor').hide();", 200);
		 				    					inicializaForma('formaMenu','grupo' );
		 				    					$('#Integrantes').html("");
		 				    					if(maxms==0){
		 				    						
		 				    						mensajeSis('El Producto de Crédito no Admite Mujeres Solteras, verifique las solicitudes de este Grupo.'); 
		 				    						
		 				    					}else{
		 				    						mensajeSis('Se ha superado el Número Máximo de Mujeres Solteras para el Grupo. Verfique el Producto de Crédito.'); 	
		 				    					}
		 				    					
		 				    					
		 				    				}else{
		 				    					if(maxm<numerom){
		 				    						$('#grupo').val(0);
		 				    						$('#nombreGrupo').val('');
				 				    				$('#cicloActual').val('');
				 				    				
		 				    						setTimeout("$('#grupo').focus().select();",0);
		 				    						setTimeout("$('#cajaListaContenedor').hide();", 200);
		 				    						inicializaForma('formaMenu','grupo' );
		 				    						$('#Integrantes').html("");
		 				    						if(maxm==0){
		 				    							mensajeSis('El Producto de Crédito no Admite Mujeres, verifique las solicitudes de este Grupo.');  
			 				    					}else{
			 				    						mensajeSis('Se ha superado el Número Máximo de Mujeres para el Grupo. Verfique el Producto de Crédito.'); 	
			 				    					}
		 				    						
		 				    						
		 					    				}else{
		 					    					if(maxh<numeroh){
		 					    						$('#grupo').val(0);
		 					    						$('#nombreGrupo').val('');
		 			 				    				$('#cicloActual').val('');
		 			 				    				
		 						    					setTimeout("$('#grupo').focus().select();",0);
		 						    					setTimeout("$('#cajaListaContenedor').hide();", 200);
		 						    					inicializaForma('formaMenu','grupo' );
		 						    					$('#Integrantes').html("");
		 						    					if(maxh==0){
		 						    						mensajeSis('El Producto de Crédito no Admite Hombres, verifique las solicitudes de este Grupo.');  
				 				    					}else{
				 				    						mensajeSis('Se ha superado el Número Máximo de Hombres para el Grupo. Verfique el Producto de Crédito.'); 	
				 				    					}
		 						    				}else{
			 					    					if((maxm-minms)<(numerom-numeroms)){
			 					    						$('#grupo').val(0);
			 					    						$('#nombreGrupo').val('');
			 			 				    				$('#cicloActual').val('');
			 			 				    				
			 						    					setTimeout("$('#grupo').focus().select();",0);
			 						    					setTimeout("$('#cajaListaContenedor').hide();", 200);
			 						    					inicializaForma('formaMenu','grupo' );
			 						    					$('#Integrantes').html("");
			 						    					if((maxm-minms) == 0){
			 						    						mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras, verifique las solicitudes de este Grupo.');  
					 				    					}else{
					 				    						mensajeSis('Se ha superado el Número Máximo de Mujeres con Estado Civil Diferente Solteras para el Grupo, verifique las solicitudes de este Grupo.'); 	
					 				    					}
			 						    				}
			 										}
		 										}
		 						    		}
		 					    		}
		 				    		
		 	    					}else{
		 	    						mensajeSis('El Grupo No Existe');
		 	    					}
		 	    				} // fin callback
		 	    				});
		    				 }
		    			}
	    			}else{
	    			mensajeSis('El Producto de Crédito Ingresado No existe.');
	    		}
	    		} //fin callback dos
			});
			
	 	}
	 }