/**
 * Controla la pantalla de Rompimiento de grupo
 */
/* consulta parametros de usuario y sesion */
var parametrosBean = consultaParametrosSession();
var nombreCliente = '';
var permiteRompimiento = '';



$(document).ready(function() {

	$("#grupoID").focus();
	
	
	/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
		
	/*le da formato de moneda, calendario, etc */
	agregaFormatoControles('formaGenerica');
	
	$("#divIntegrantes").hide();
	$("#trMotivo").hide();
	deshabilitaBoton('procesar', 'submit');
	
	
	var tipoTransaccion= {
			'procesar' : '1'
		};

	var tipoConsultaGrupo = {
			'principal'	: 1
		  		
		};	


	
	  $('#grupoID').bind('keyup',function(e){
		 if(this.value.length >= 2){ 
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
		    	camposLista[0] = "nombreGrupo";
		    	parametrosLista[0] = $('#grupoID').val();
		 lista('grupoID', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm'); } 
	  });	 
	 
		$('#grupoID').blur(function() { 
	  		consultaGrupo(this.id); 
		});
		
		
		 
		$('#procesar').click(function() { 
			$('#tipoTransaccion').val(tipoTransaccion.procesar);
		});
		
		
		
		/*esta funcion esta en forma.js, verifica que el mensaje d error o exito aparezcan correctamente y que realizara despues de cada caso */
		$.validator.setDefaults({		
		    submitHandler: function(event) { 
		    	var desintegrar = confirm("Está Seguro de Quitar como Integrante del Grupo: " + $("#nombreGrupo").val() + "\n" + " A " + nombreCliente);
		        if (desintegrar == true) {
		        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','grupoID',
			    											 'funcionExitoRompimientoGrupo','funcionFalloRompimientoGrupo'); 
		        } else {
		        	return false;
		        }			
		      }
		 });
		

		/* =============== VALIDACIONES DE LA FORMA ================= */
			$('#formaGenerica').validate({			
				rules: {
					grupoID :{
						required:true,
					},
					motivo :{
						required:true,
						maxlength: 500
					}
				},		
				messages: {
					grupoID :{
						required:'Especificar Grupo',
					},
					motivo :{
						required:'Especificar Motivo',
						maxlength: 'Máximo 500 caracteres'
					}
				}		
			});

		
			
			
			/* =================== FUNCIONES ========================= */
			function consultaGrupo(control) {
				deshabilitaBoton('procesar','submit');
				$("#trMotivo").hide(400);
				var grupoID = $('#grupoID').val();
				var estatusGrupo = '';
				setTimeout("$('#cajaLista').hide();", 200);
				if(grupoID != '' && !isNaN(grupoID)){
					var grupoBeanCon = { 
			  				'grupoID':$('#grupoID').val()
						};
							 
						gruposCreditoServicio.consulta(tipoConsultaGrupo.principal,grupoBeanCon,function(grupo) {
								if(grupo!=null){
									dwr.util.setValues(grupo);	
									switch(grupo.estatusCiclo){
										case 'A':
											estatusGrupo = 'ABIERTO';
											 break;
										case 'C':
											estatusGrupo = 'CERRADO';
											 break;
										case 'N':
											estatusGrupo = 'NO INICIADO';
											 break;
									}
									$("#estatusCiclo").val(estatusGrupo);
									
									$("#producCreditoID").val(grupo.productoCre);
									consultaProducto('producCreditoID');									
									
								}
								else{
									mensajeSis("El Grupo No Existe.");		
									limpiaFormulario();
								}
						});
				}
				else{
					limpiaFormulario();
				}
			}
			
			
			function consultaProducto(idControl) {
				var jqProducto = eval("'#" + idControl + "'");
				var numProducto = $(jqProducto).val();	
				var tipConPrincipal = 1;
				var productoBeanCon = { 
		  				'producCreditoID':numProducto		  				
					};
				setTimeout("$('#cajaLista').hide();", 200);		
				if(numProducto != '' && !isNaN(numProducto)){
					productosCreditoServicio.consulta(tipConPrincipal,productoBeanCon,function(productos) {
						if(productos!=null){	
									$('#producCreditoIDDes').val(productos.descripcion);
									
									if (productos.perRompimGrup == 'S'){
										mostrarIntegrantesGrupo();
									}
									else{
										mensajeSis("El Producto de Crédito No Permite Rompimiento de Grupo.");		
										limpiaFormulario();
									}
																			
								}else{
									mensajeSis("El Producto de Crédito No Existe.");									
								}    	 						
						});
					}
				 else{
					 $("#producCreditoIDDes").val('');
				 }
			}	
			
			
			
			function mostrarIntegrantesGrupo(){
				var numRenglones;				
				
					var params = {};
					params['tipoLista'] = 11;
					params['grupoID'] = $("#grupoID").val();
					params['cicloGrupo'] = $("#cicloActual").val();
					 
					$.post("rompimientoGrupoGridVista.htm", params, function(integrantes){
						$('#divIntegrantes').html(integrantes);					
											
						$('#divIntegrantes').show(400);	
						agregaFormatoControles('formaGenerica');
						
						numRenglones  = consultaFilas(); 
						
						if(parseInt(numRenglones) > 0){
							$("#integrante1").attr('checked', true);
							desintegrarGrupo(1);
						}
						else{
							$("#grupoID").focus();
							$("#grupoID").select();
						}
					});
				}
			
			
	
			function consultaFilas(){
				var totales=0;
				$('tr[name=renglon]').each(function() {
					totales++;
					
				});
				return totales;
			}
			
			
			
			function limpiaFormulario(){
				$("#grupoID").focus();
				$("#grupoID").select();
				$("#nombreGrupo").val('');
				$("#cicloActual").val('');
				$("#producCreditoID").val('');
				$("#producCreditoIDDes").val('');
				$("#estatusCiclo").val('');
				$("#nombreSucursal").val('');
				
				$("#divIntegrantes").hide(400);
				$("#trMotivo").hide(400);
				
				deshabilitaBoton('procesar','submit');
			}
	
});




function desintegrarGrupo(renglon){
	nombreCliente ='';
	$("#trMotivo").show(400);
	$("#motivo").val('');
	$("#motivo").focus();
	habilitaBoton('procesar','submit');
	$("#usuarioID").val(parametrosBean.numeroUsuario);
	$("#sucursalID").val(parametrosBean.sucursal);	
	$("#solicitudCreditoID").val($(eval("'#solicitudCreditoID" + renglon + "'")).val());
	
	nombreCliente =  $(eval("'#nombreCliente" + renglon + "'")).val();
}


function funcionExitoRompimientoGrupo(){
	inicializaForma('formaGenerica', 'grupoID');
	$("#divIntegrantes").hide(400);
	$("#trMotivo").hide(400);
	deshabilitaBoton('procesar','submit');
}

function funcionFalloRompimientoGrupo(){
	
}
