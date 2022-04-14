$(document).ready(function() {		
	//------------ Metodos y Manejo de Eventos -----------------------------------------
 //limpiarFormularioBloqueoTarjeta();

	var catTransaccionGiroTipoTarjeta = {
		'grabar':'2'	
	};
	var catTipoConsultaTipoTarjeta = {
	  		'tipoTarjetaCte':1	  		
	};
	deshabilitaBoton('grabar','submit');
	$('#tipoTarjetaDebID').focus();
	$(':text').focus(function() {
	 	esTab = false;
	});
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTransaccionGiroTipoTarjeta.grabar);
		guardarGiros();
	});
	
	$.validator.setDefaults({			
	      submitHandler: function(event) { 	    	  
	    			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoTarjetaDebID', 'funcionExitoGiroNegTar','funcionErrorGiroNegTar');
	    }
	});	

		$('#coorporativo').blur(function() {
		consultaTarCoorpo(this.id);
		
		});

		$('#tipoTarjetaDebID').blur(function(){
			if($('#tipoTarjetaDebID').val() != ''){
				validaTipoTarjetaDebito(this.id);		
			}else{
				funcionExitoGiroNegTar();	
			}
		

		});
		
		$(':text').bind('keydown',function(e){ 
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});
	
		$('#coorporativo').bind('keyup',function(e){
			lista('coorporativo', '1', '3', 'nombreCompleto', $('#coorporativo').val(), 'listaCliente.htm');
		});
		
		$('#tipoTarjetaDebID').bind('keyup',function(e){
			lista('tipoTarjetaDebID', '1', '4', 'tipoTarjetaDebID', $('#tipoTarjetaDebID').val(), 'tipoTarjetasDevLista.htm');
		});
			
		function consultaTarCoorpo(idControl) {
			var jqCoorpo = eval("'#" + idControl + "'");
			var coorporativo = $(jqCoorpo).val();
			var consulTarCoorpo = 12;
			setTimeout("$('#cajaLista').hide();", 200);
			if ( coorporativo!=''  && !isNaN(coorporativo)  && esTab) {
				clienteServicio.consulta(consulTarCoorpo, coorporativo,"",function(cliente) {
					if (cliente != null) {					
						$('#coorporativo').val(cliente.numero);						
						$('#nombreCoorp').val(cliente.nombreCompleto);
						consultaGiroNegocioTarDeb('coorporativo');
						habilitaBoton('grabar', 'submit');
					} else {
						alert("No Existe el Corporativo Relacionado.");				
						$('#nombreCoorp').val('');
						$('#gridGiroNegocioxTipoTarCliCorpor').html("");
						$('#gridGiroNegocioxTipoTarCliCorpor').hide(); 
						$('#coorporativo').focus();					
					}
				});
			}
		}
	
		function validaTipoTarjetaDebito(control) {
			var tipoTarjetaDeb = $('#tipoTarjetaDebID').val();
			setTimeout("$('#cajaLista').hide();", 200);
			if(tipoTarjetaDeb != ''  && !isNaN(tipoTarjetaDeb) && esTab){
				var tipoTarjetaBeanCon = { 
		  		'tipoTarjetaDebID':$('#tipoTarjetaDebID').val()
		  				};
				tipoTarjetaDebServicio.consulta(catTipoConsultaTipoTarjeta.tipoTarjetaCte,tipoTarjetaBeanCon,function(tipoTarDeb) {
						if(tipoTarDeb!=null){
							$('#nombreTarjeta').val(tipoTarDeb.descripcion);
							$('#tipoTarjeta').val(tipoTarDeb.tipoTarjeta);
							if(tipoTarDeb.identificacionSocio=='S'){
								alert('El Tipo de Tarjeta es de Identificación.');
								limpiaForm($('#formaGenerica'));	
								$('#tipoTarjetaDebID').focus();
								$('#gridGiroNegocioxTipoTarCliCorpor').html("");
								$('#gridGiroNegocioxTipoTarCliCorpor').hide(); 
								$('#nombreTarjeta').val('');
								$('#tipoTarjeta').val('');
								deshabilitaBoton('grabar', 'submit');
							}
						}else{		
							alert("El Tipo de Tarjeta No Existe");
							limpiaForm($('#formaGenerica'));	
							$('#tipoTarjetaDebID').focus();
							$('#gridGiroNegocioxTipoTarCliCorpor').html("");
							$('#gridGiroNegocioxTipoTarCliCorpor').hide(); 
							$('#nombreTarjeta').val('');
							$('#tipoTarjeta').val('');
							}
						});	
				}
			}
		$('#formaGenerica').validate({
			rules : {
				tipoTarjetaDebID: {
					required : true,
				},
				tipoCuenta: {
					required : true,
				}
	
			},
			messages : {
				tipoTarjetaDebID:{
					required: 'Especifique el Tipo de Tarjeta.',
				},
				tipoCuenta:{
					required: 'Especifique el Tipo de Cuenta.',
				}
			}
		});
	
	function consultaGiroNegocioTarDeb(){			
		var tipoTarDebID=$('#tipoTarjetaDebID').val();
		var clienteCorp=$('#coorporativo').val();
		esTab = true;
		if (tipoTarDebID == ''){
			alert("Especifica el número el Tipo de Tarjeta");
			$('#tipoTarjetaDebID').focus();
			$('#gridGiroNegocioxTipoTarCliCorpor').html("");
			$('#gridGiroNegocioxTipoTarCliCorpor').hide(); 
		
		} else if(clienteCorp != '' && esTab){
	
	
			var params = {};
			params['tipoLista'] = 1;
			params['tipoTarjetaDebID'] = tipoTarDebID;
			params['coorporativo'] = clienteCorp;
			
			$.post("gridGiroNegocioxTipoTarCliCorpor.htm", params, function(data){
				if(data.length >0) {
					$('#gridGiroNegocioxTipoTarCliCorpor').html(data);
					$('#gridGiroNegocioxTipoTarCliCorpor').show();				
				}else {	
					
					$('#gridGiroNegocioxTipoTarCliCorpor').html("");
					$('#gridGiroNegocioxTipoTarCliCorpor').hide(); 
				}
			});
		}
		$('#gridGiroNegocioxTipoTarCliCorpor').html("");
		$('#gridGiroNegocioxTipoTarCliCorpor').hide(); 
	}
	
});

	
	
	function agregarGiroNegocio(){	
		var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		 	 	  
			if(numeroFila == 0){
				tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
				tds += '<input  id="giroID'+nuevaFila+'" name="lnumGiro"  size="6"  value="" autocomplete="off"   onkeypress="listaGiros(this.id)" onblur="validaGiroTarjeta(this.id);"/> </td>';								
				
				
				tds += '<td><input  id="descripcion'+nuevaFila+'" name="ldescripGiro"  size="60"  autocomplete="off" readOnly="true" type="text" onkeyPress="return Validador(event);"/></td>';			
			} else{    		
				var valor = numeroFila+ 1;
				tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+valor+'" autocomplete="off"  type="hidden"/></td>';
				tds += '<td><input  id="giroID'+nuevaFila+'" name="lnumGiro"  size="6"  value="" autocomplete="off" onkeypress="listaGiros(this.id)" onblur="validaGiroTarjeta(this.id);" /></td>';								
					
				tds += '<td><input  id="descripcion'+nuevaFila+'" name="ldescripGiro"  size="60"  autocomplete="off" readOnly="true"  type="text" onkeyPress="return Validador(event);" /></td>';			
			}
			tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarGiroNegocio(this.id)"/></td>';
			tds += '<td><input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarGiroNegocio()"/></td>';
			tds += '</tr>';	   	   
			 
			$("#miTabla").append(tds);
			return false;		
		}
	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;		
		});
		return totales;
	}
	
	
	function eliminarGiroNegocio(control){	
		var contador = 0 ;
		var numeroID = control;
		
		var jqRenglon = eval("'#renglon" + numeroID + "'");
		var jqNumero = eval("'#consecutivoID" + numeroID + "'");
		var jqGiros = eval("'#giroID" + numeroID + "'");		
		var jqGiro = eval("'#giroId" + numeroID + "'");
		var jqDescripcion=eval("'#descripcion" + numeroID + "'");
		var jqAgrega=eval("'#agrega" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");
	
		// se elimina la fila seleccionada
		$(jqNumero).remove();
		$(jqGiros).remove();
		$(jqGiro).remove();
		$(jqElimina).remove();
		$(jqDescripcion).remove();
		$(jqAgrega).remove();
		$(jqRenglon).remove();
	
		//Reordenamiento de Controles
		contador = 1;
		var numero= 0;
		$('tr[name=renglon]').each(function() {		
			numero= this.id.substr(7,this.id.length);
			var jqRenglon1 = eval("'#renglon"+numero+"'");
			var jqNumero1 = eval("'#consecutivoID"+numero+"'");
			var jqGiros1 = eval("'#giroID"+numero+"'");		
			var jqGiro1= eval("'#giroID"+numero+"'");
			var jqDescripcion1=eval("'#descripcion"+ numero+"'");
			var jqAgrega1=eval("'#agrega"+ numero+"'");
			var jqElimina1 = eval("'#"+numero+ "'");
		
			$(jqNumero1).attr('id','consecutivoID'+contador);
			$(jqGiros1).attr('id','giroID'+contador);
			$(jqGiro1).attr('id','giroID'+contador);
			$(jqDescripcion1).attr('id','descripcion'+contador);
			$(jqAgrega1).attr('id','agrega'+contador);
			$(jqElimina1).attr('id',contador);
			$(jqRenglon1).attr('id','renglon'+ contador);
			contador = parseInt(contador + 1);	
			
		});
		
	}
		function verificaSeleccionado(idCampo){
			var contador = 0;
			var nuevoGiro		=$('#'+idCampo).val();
		var numeroNuevo= idCampo.substr(6,idCampo.length);
		var jqDescripcion 	= eval("'descripcion" + numeroNuevo+ "'");
		$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdGiros = eval("'giroID" + numero+ "'");
					
		var valorGiros = $('#'+jqIdGiros).val();
		if(jqIdGiros != idCampo){
			if(valorGiros == nuevoGiro ){
				alert("El Número de Giro ya Existe");
				$('#'+idCampo).focus();
				$('#'+idCampo).val("");
				$('#'+jqDescripcion).val("");
						contador = contador+1;
					}		
				}
			});		
			return contador;
		}
	
	function listaGiros(idControl){
		var jq = eval("'#" + idControl + "'");
		$(jq).bind('keyup',function(e){
			var jqControl = eval("'#" + this.id + "'");
			var num = $(jqControl).val();
				
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "giroID"; 
			parametrosLista[0] = num;
			lista(idControl, '1', '1', camposLista, parametrosLista, 'giroNegTarDebLista.htm');
		});
	}
	
	function validaGiroTarjeta(control) {
		var jq = eval("'#" + control + "'");	
		var tipoTarjetaDeb = $(jq).val();
	var principal=1;
		var jqDescripcion = eval("'#descripcion" + control.substr(6) + "'");	
		setTimeout("$('#cajaLista').hide();", 200);
			if(tipoTarjetaDeb != '' && !isNaN(tipoTarjetaDeb) && esTab){
				var tipoTarjetaBeanCon = { 
						'giroID':tipoTarjetaDeb
				};
				if(verificaSeleccionado(control) == 0){
				
					giroNegocioTarDebServicio.consulta(principal,tipoTarjetaBeanCon,function(tipoTarDeb) {
						if(tipoTarDeb!=null){
							$(jqDescripcion).val(tipoTarDeb.descripcion);		
							}else{
								alert("El Número de Giro no Existe");
								$(jq).val("");
								$(jqDescripcion).val("");
								$(jq).focus();
								
							}
					});	
				}
			}else {
				$(jq).val("");
				$(jqDescripcion).val("");
			}
	}			
	function guardarGiros(){		
			var mandar = verificarvacios();
	
			if(mandar!=1){   		  		
			var numCodigo = $('input[name=consecutivoID]').length;
			
			$('#giros').val("");
			for(var i = 1; i <= numCodigo; i++){
				if(i == 1){
					$('#giros').val($('#giros').val() +
					document.getElementById("giroID"+i+"").value + ']' +
					document.getElementById("descripcion"+i+"").value);
				}else{
					$('#giros').val($('#giros').val() + '[' +
					document.getElementById("giroID"+i+"").value + ']' +
					document.getElementById("descripcion"+i+"").value);			
				}	
			}
		}
		else{
		
			alert("Especifique el Número de Giro");
			event.preventDefault();
		}
	}	

	
	function verificarvacios(){	
		quitaFormatoControles('gridGiros');
		var numCodig = $('input[name=consecutivoID]').length;
		
		$('#giros').val("");
		for(var i = 1; i <= numCodig; i++){	
			var idcr = document.getElementById("giroID"+i+"").value;
				if (idcr ==""){
					document.getElementById("giroID"+i+"").focus();				
				$(idcr).addClass("error");	
					return 1; 
				}
			var idcde = document.getElementById("descripcion"+i+"").value;
				if (idcde ==""){
					document.getElementById("descripcion"+i+"").focus();
				$(idcde).addClass("error");
					return 1; 
				}			
		}
	}


	//funcion que se ejecuta cuando el resultado fue exito
	function funcionExitoGiroNegTar(){
		
		$('#tipoTarjetaDebID').val('');
		$('#tipoTarjetaDebID').focus();
		$('#giroID').val('');
		$('#descripcion').val('');
		$('#nombreCoorp').val('');
		$('#coorporativo').val('');
		$('#gridGiroNegocioxTipoTarCliCorpor').html("");
		$('#gridGiroNegocioxTipoTarCliCorpor').hide(); 
		$('#nombreTarjeta').val('');
		$('#tipoTarjeta').val('');
	}
	
	// funcion que se ejecuta cuando el resultado fue error
	// diferente de cero
	function funcionErrorGiroNegTar(){
	}