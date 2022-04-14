/**
 * js para la pantalla de la afiliacion y baja de las cuentas clabe.
 */

$(document).ready(function(){
	$('#afiliacionID').focus();
	
	esTab= false;
	bancoNomina= null;
	
	  // Definicion de Constantes y Enums
    var catTipoTransaccionDom = {
    		'grabar':1
    };

	//----------------------------metodos y manejo de eventos--------------------------
	deshabilitaBoton('agrega','submit');
	agregaFormatoControles('FormaGenerica');
	deshabilitaControl('clienteID');
	$(':text').focus(function(){
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#afiliacionID').bind('keyup',function(){
		var NumNom=$('#afiliacionID').val();
		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "nombreArchivo";
		parametrosLista[0] = NumNom;		
		lista('afiliacionID', '3', '4', camposLista, parametrosLista, 'afiliacionBajaCtasClabeLista.htm');
		
	});
	
	$('#afiliacionID').blur(function(){
		validaAfiliacion(this.id);
		
	});

	$('#tipoAfiliacion').blur(function(){
		$('#gridAfiliacionBaja').html("");
		$('#botonesGrid').attr('style','display:none');

	});
	
	 $.validator.setDefaults({
			submitHandler : function(event) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'false','afiliacionID','exito', 'error');
			}
	 });
	 
	 
	 $('#formaGenerica').validate({			
			rules: {
			},		
			messages: {
			}		
		
	 });
	
	 
	 $('#clienteID').bind('keyup',function(e){
			var NumNom=$('#clienteID').val();
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "nombreCompleto";
			camposLista[1] = "institNominaID";
			camposLista[2] = "convenio";
			camposLista[3] =  "estatus";

			var tipoAfiliacion = $('#tipoAfiliacion').val();
			parametrosLista[0] = NumNom;
			if($('#esNominaSi').attr('checked') == true ){
				parametrosLista[1] = $('#instNominaID').val();
				parametrosLista[2] = $('#convenio').val();
				if($('#convenio').val()==0 &&  $('#instNominaID').val()!=0){
					$('#convenio').focus();
					mensajeSis("Debe seleccionar un Convenio.");
				}

			}else if($('#esNominaNo').attr('checked') == true ){
				parametrosLista[1] = 0;
				parametrosLista[2] = 0;
			}
			
			parametrosLista[3] = tipoAfiliacion;		
					lista('clienteID', '2', '1', camposLista, parametrosLista, 'afiliaClienteNominaLista.htm');
	});
	
	 
	$('#clienteID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
		validaCliente(this.id);
		}else{
			$('#clienteID').focus();
		}
	});
	
	$("#generarLayout").click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionDom.grabar);
	});
	
	
	
	$("#agrega").click(function() {
		if($('#esNominaSi').attr('checked') != false || $('#esNominaNo').attr('checked') != false){
			if($('#esNominaSi').attr('checked') == true){
				if($('#instNominaID').val()!=""){
					if($('#convenio').val()!=0||$('#instNominaID').val()==0){
						if($('#tipoAfiliacion').val()!=""){
							if($('#clienteID').val()!=""){
								bloquearPantalla();
								cargaGrid();

							}else{
								$('#clienteID').focus();
								mensajeSis("El campo Cliente no debe estar Vacío.");
							}
						}else{
							$('#tipoAfiliacion').focus();
							mensajeSis("Debe Seleccionar un Tipo de Afiliación.");
						}
					}else{
						$('convenio').focus();
						mensajeSis("Debe seleccionar un Número de Convenio.");
					}
					
				}else{
					$('#instNominaID').focus();
					mensajeSis("La Empresa de Nómina no debe estar Vacío.");
				}	
			}else{
				if($('#esNominaNo').attr('checked') == true){
					if($('#tipoAfiliacion').val()!=""){
						if($('#clienteID').val()!=""){
							bloquearPantalla();
							cargaGrid();
						
						}else{
							$('#clienteID').focus();
							mensajeSis("El campo Cliente no debe estar Vacío.");
						}
					}else{
						$('#tipoAfiliacion').focus();
						mensajeSis("Debe Seleccionar un Tipo de Afiliación.");
					}
				}
			}
			
		}else{
			mensajeSis("Debe Seleccionar si el registro será o no de Nómina.");
		}
		
	});
	
	
	$('#esNominaSi').click(function(){
		if($('#esNominaSi').attr('checked') == true){
			$('#gridAfiliacionBaja').html("");
			$('#gridAfiliacionBaja').hide();
			$('#botonesGrid').attr('style','display:none');
			$('#esNomina').val("S");
			$('#instNominaID').val("");
			$('#nombreInstNomina').val("");
			$('#convenio').val("");
			$('#clienteID').val("");
			$('#nombreCliente').val("");
			document.getElementById("soloNomina").style.display = '';
		}
	});
	
	
	$('#esNominaNo').click(function(){
		if($('#esNominaNo').attr('checked') == true){

			$('#gridAfiliacionBaja').html("");
			$('#gridAfiliacionBaja').hide();
			$('#botonesGrid').attr('style','display:none');

			$('#esNomina').val("N");
			$('#instNominaID').val("");
			$('#nombreInstNomina').val("");
			$('#convenio').val("");
			$('#clienteID').val("");
			$('#nombreCliente').val("");
			habilitaControl('clienteID');
			document.getElementById("soloNomina").style.display = 'none';
			limpiaCombo();
			
		}
	});
	
	
	$('#instNominaID').bind('keyup',function(e){
		var NumNom=$('#instNominaID').val();
		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "institNominaID"; 

		parametrosLista[0] = NumNom;

		lista('instNominaID', '2', '1', camposLista,parametrosLista,'institucionesNomina.htm');
		
	});
	
	
	$('#instNominaID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
		consultaInstitucion(this.id);
		}else{
			$('#instNominaID').focus();
		}
	});
	
	
	
	
});

/*************************************************/
/*		FUNCION PARA LA PAGINACION DEL GRID		*/
/************************************************/
function cargaGrid(pageValor){
	var numFilas = consultaFilas();
	var params ={};
	var lisComentarioP;
	var lisClienteIDP;
	$("input[name='lisComentario']").each(function(){
			lisComentarioP = lisComentarioP+","+$(this).val();
		});
		
		$("input[name='lisClienteID']").each(function(){
			lisClienteIDP = lisClienteIDP+","+$(this).val();
		});
	params['clienteID'] = $('#clienteID').val();
	
		params['tipoLista'] = '2';
	
	if($('#esNominaNo').attr('checked') == true){
		params['institNominaID'] = '0';
		params['esNomina'] = 'N';
		params['convenio'] = '0';
	}
	
	if($('#esNominaSi').attr('checked') == true){
		params['institNominaID'] = $('#instNominaID').val();
		params['esNomina'] = 'S';
		params['convenio'] = $('#convenio').val();
	}
	params['tipoAfiliacion']=$('#tipoAfiliacion').val();
	params['estatus'] = $('#estatus').val();
	params['pagina'] 	= pageValor;
	params['lisComentario'] =lisComentarioP;
	params['lisClienteID']	=lisClienteIDP;
	
	$.post("afiliacionBajaCtasClaveGrid.htm",params,function(data) {
		
		if(data.length >0) {
			
			$('#gridAfiliacionBaja').show();
			$('#gridAfiliacionBaja').html(data);
			$('#botonesGrid').attr('style',display='');
			 var numFilas = consultaFilas();
			 if(numFilas>0){
			 	$('#gridAfiliacionBaja').show();
				$('#gridAfiliacionBaja').html(data);
				$('#botonesGrid').attr('style',display='');
	       }else{
	       	console.log("console"+numFilas);
			$('#gridAfiliacionBaja').html("");
			$('#gridAfiliacionBaja').hide();
			$('#botonesGrid').attr('style','display:none');
		    }
		}else{
			$('#gridAfiliacionBaja').html("");
			$('#gridAfiliacionBaja').hide();
			$('#botonesGrid').attr('style','display:none');
		}
		});
	desbloquearPantalla();
}




function consultaInstitucion(idControl){
	var jqInstitucionID = eval("'#"+idControl+"'");
	var numInstNomina = $(jqInstitucionID).val();
	
		if(numInstNomina !='' && esTab){
			var numConsulta = 1;
			if(numInstNomina !=0){
			var institucionNominaBean = {
				'institNominaID' : numInstNomina
			};

			institucionNomServicio.consulta(numConsulta,institucionNominaBean,function(institucion){
				if(institucion !=null){
					$('#nombreInstNomina').val(institucion.nombreInstit);
					cargaCombo(numInstNomina);
					habilitaControl('clienteID');
				}else{
					mensajeSis("No Existe la Empresa de Nómina.");
					$('#instNominaID').focus();
					$('#instNominaID').val("");
					$('#nombreInstNomina').val("");
				}
		
			});
		}
		if(numInstNomina == 0){
			dwr.util.removeAllOptions('convenio');
			dwr.util.addOptions('convenio', {'0':'SELECCIONAR'});
			$('#nombreInstNomina').val('TODAS');
			$('#clienteID').val('0');
			$('#nombreCliente').val('TODOS');
		}
			
	}else{
		function validaBoton(){
			if(texto = 'deshabilitado'){
			deshabilitaBoton('generarLayout','submit');
			}
		}

		mensajeSis("La Empresa no Existe.");
	}
}


function validaAfiliacion(idControl){
	var jqAfiliacion = eval("'#"+idControl+"'");
	var numAfiliacion = $(jqAfiliacion).val();
	
	setTimeout("$('#cajaLista').hide();", 200);
	if(numAfiliacion != '' && !isNaN(numAfiliacion) && esTab){
		if(numAfiliacion=='0'){
			habilitaBoton('agrega','submit');
			//inicializaForma('formaGenerica','afiliacionID');
			$('#esNominaSi').attr("checked", false);
			$('#esNominaNo').attr("checked", false);
			$('#instNominaID').val("");
			$('#nombreInstNomina').val("");
			$('#convenio').val("");
			$('#tipoAfiliacion').val("");
			$('#clienteID').val("");
			$('#nombreCliente').val("");
			$('#estatusFolio').val("Sin Procesar");
			$('#estatus').val('S');
			limpiaCombo();
			deshabilitaControl('clienteID');
			$('#gridAfiliacionBaja').html("");
			$('#botonesGrid').attr('style','display:none');
			habilitaBoton('generarLayout','submit');
		}else{
			var afiliacionBajaCtasClabeBean = {
					'folioAfiliacion' : numAfiliacion,
					 'tipoLista' : 1
			};
			afiliacionBajaCtasClabeServicio.consulta(3,afiliacionBajaCtasClabeBean,function(datos){
				if(datos!=null){
					$('#afiliacionID').val(datos.folioAfiliacion);
					if(datos.esNomina =='S'){
						$('#esNominaSi').attr('checked',true);
						$('#instNominaID').val(datos.institNominaID);
						$('#nombreInstNomina').val(datos.nombreEmpNomina);
						cargaCombo(datos.institNominaID);

						$('#convenio').val(datos.convenio);
						document.getElementById("soloNomina").style.display = '';
					}else{
						$('#instNominaID').val("");
						$('#nombreInstNomina').val("");
						$('#convenio').val("");
						document.getElementById("soloNomina").style.display = 'none';

						$('#esNominaNo').attr('checked',true);
					}
					$('#esNomina').val(datos.esNomina);
					$('#tipoAfiliacion').val(datos.tipoAfiliacion);
					$('#clienteID').val(datos.clienteID);
					$('#nombreCliente').val(datos.nombreCompleto);
					if(datos.estatus == 'S'){
						$('#estatusFolio').val('Sin Procesar');
					}else{
						$('#estatusFolio').val('Procesado');
					}
					
					$('#estatus').val(datos.estatus);
				}else{
					$('#afiliacionID').focus();
					mensajeSis('El Folio de Afiliación No existe.');
				}
			});
			
			var params ={};
			params['folioAfiliacion'] = numAfiliacion;
			params['tipoLista'] = '5';

			bloquearPantalla();
			$.post("afiliacionBajaCtasClaveGrid.htm",params,function(data) {
				if(data.length >0) {
				$('#gridAfiliacionBaja').html(data);
				$('#gridAfiliacionBaja').show();
				$('#botonesGrid').attr('style','display:');
				}else{
					$('#gridAfiliacionBaja').html("");
					$('#gridAfiliacionBaja').hide();
				}
				});
			
			
			deshabilitaBoton('agrega','submit');
			deshabilitaBoton('generarLayout','submit');
			desbloquearPantalla();
			
		}
	}
}


function validaCliente(idControl){
	var jqClienteID = eval("'#"+idControl+"'");
	var numCliente = $(jqClienteID).val();
	
	if(numCliente !=''&& esTab){
		var numConsulta = 1;
		if(numCliente != 0){
			if($('#esNominaNo').attr('checked') == true){
				$('#instNominaID').val('0');
			}
				var cliente = {
						'clienteID' : $('#clienteID').val(),
						'institNominaID' : $('#instNominaID').val(),
						'tipoAfiliacion' : $('#tipoAfiliacion').val()
				}
				afiliacionBajaCtasClabeServicio.consulta(numConsulta,cliente,function(cliente) {
				if(cliente !=null){
					$('#clienteID').val(cliente.clienteID);
					$('#nombreCliente').val(cliente.nombreCompleto);
				
			}else{
				if($('#esNominaSi').attr('checked') == true){
					mensajeSis('El Cliente no es de Nómina o No tiene una Cuenta Destino Registrada.');
					$('#clienteID').focus();
				}
				if($('#esNominaNo').attr('checked') == true){
					mensajeSis('El Cliente es de Nómina o No tiene una Cuenta Destino Registrada.');
					$('#clienteID').focus();
				}
				$('#clienteID').val("");
				$('#nombreCliente').val("");
	
				
			}
			
			});
		}
		if(numCliente == 0){
			$('#nombreCliente').val('TODOS');
		}
	}else{
		mensajeSis("El Cliente no Existe.");
	}
}

function cargaCombo(numInstNomina){
	var listaConvenio = new Array();
	var numLista = 3;
	var institucionNominaBean = {
			'institNominaID' : numInstNomina
		};
	dwr.util.removeAllOptions('convenio');
	dwr.util.addOptions('convenio', {'0':'SELECCIONAR'});
	afiliacionBajaCtasClabeServicio.lista(numLista,institucionNominaBean,{async:false,callback:function(datos){
		
			listaConvenio = datos;
			
			for(var i=0; i<listaConvenio.length; i++){
				   $('#convenio').append('<option value="'+listaConvenio[i].convenio+'">' + "Convenio - "+listaConvenio[i].convenio + '</option>');
			   }
		}
	});
}

function limpiaCombo(){
	  var selectobject=document.getElementById("convenio");
	  //var options = theSelect.getElementsByTagName('OPTION');
	  for (var i=selectobject.length-1; i>0; i--){
	     selectobject.remove(i);
	  }
	  
}


function eliminaDetalle(control){

   		var numeroID = control.id;
   		var jqClienteID = eval("'#clienteID" + numeroID + "'");
	
			var params={};
   	   		params['pagina'] 	= 'elimina';
   	   		params['clienteEliminado'] = $(jqClienteID).val();
   	   		params['tipoLista'] = '2';
   	   		params['lisComentario']='';
   	   		params['lisClienteID']='';
   	   		bloquearPantalla();
   			$.post("afiliacionBajaCtasClaveGrid.htm",params,function(data) {
   				if(data.length >0) {
   				$('#gridAfiliacionBaja').html(data);
   				$('#botonesGrid').attr('style',display='');
   				}else{
   					$('#gridAfiliacionBaja').html("");
   				}
   				});
   			desbloquearPantalla();
}



function generaExcel(){
	var lisComentario = [];
	var lisClienteID = [];
		$("input[name='lisComentario']").each(function(){
			lisComentario.push($(this).val());
		});
		
		$("input[name='lisClienteID']").each(function(){
			lisClienteID.push($(this).val());
		});
		
		var url ='reporteAfiliacionCuentaClabe.htm?lisClienteID='+lisClienteID+'&lisComentario='+lisComentario;
		window.open(url);
}



function exito(){
	$('#esNominaSi').attr("checked", false);
	$('#esNominaNo').attr("checked", false);
	$('#instNominaID').val("");
	$('#nombreInstNomina').val("");
	$('#convenio').val("");
	$('#tipoAfiliacion').val("");
	$('#clienteID').val("");
	$('#nombreCliente').val("");
	$('#estatusFolio').val("Sin Procesar");
	$('#estatus').val('S');
	$('#gridAfiliacionBaja').html("");
	$('#gridAfiliacionBaja').hide();
	$('#botonesGrid').attr('style','display:none');
	limpiaCombo();
	deshabilitaControl('clienteID');
	
	var url ='expAfiliacionBajaCtaClabe.htm?consecutivo='+$('#consecutivo').val();
	window.open(url);
}

function error(){
	

}


/*    cuenta las filas de la tabla del grid */
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;		
	});
	return totales;
}
