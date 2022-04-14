var parametroBean = consultaParametrosSession();   
$(document).ready(function() {
	esTab = true;
	//Definicion de Constantes y Enums
	
	var catTransaccionGiroNegTarDeb = {  
	  		'grabar':'2'	
  	};
	var catGirosTipoTarjeta = {
	  		'giroTipoTarjeta':2
	};
	// ------------ Metodos y Manejo de Eventos
	$('#gridGiros').hide();
	deshabilitaBoton('grabar', 'submit');
	agregaFormatoControles('formaGenerica');
	$('#tipoTarjetaDebID').focus();
	//validacion
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
	      submitHandler: function(event) { 
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoTarjetaDebID', 
	    			  'funcionExitoGirosTipoTarjeta','funcionErrorGirosTipoTarjeta');
	      }
	});

	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTransaccionGiroNegTarDeb.grabar);
			guardarGiros();
	});
	$('#tipoTarjetaDebID').blur(function(){
		if($('#tipoTarjetaDebID').val() != ''){
			consultaTipoTarjeta();
		}else{
			funcionExitoGirosTipoTarjeta();
		}
		
	});	
	
	$('#tipoTarjetaDebID').bind('keyup',function(e){
		lista('tipoTarjetaDebID', '1', '4', 'tipoTarjetaDebID', $('#tipoTarjetaDebID').val(), 'tipoTarjetasDevLista.htm');
	});   


	// ------------ Validaciones de la Forma
	
	$('#formaGenerica').validate({
		rules : {
			tipoTarjetaDebID: {
				required : true,
			}

		},
		messages : {
			tipoTarjetaDebID:{
				required: 'Especifique el Tipo de Tarjeta.',
			}
		}
	}); 
		
	// ------------ Validaciones de Controles-------------------------------------
  function consultaTipoTarjeta() {
	var tarjetaDebID =$('#tipoTarjetaDebID').val();
	var TarjetaDebitoCon = {
		'tipoTarjetaDebID': $('#tipoTarjetaDebID').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if ( tarjetaDebID != ''  && !isNaN(tarjetaDebID) && esTab) {
		tarDebGirosNegocioServicio.consulta(catGirosTipoTarjeta.giroTipoTarjeta, TarjetaDebitoCon,function(giroTarDeb){
		if(giroTarDeb !=null){
			$('#tipoTarjetaDebID').val(giroTarDeb.tipoTarjetaDebID);
			$('#nombreTarjeta').val(giroTarDeb.nombreTarjeta);
			$('#tipo').val(giroTarDeb.tipo);
					consultagirosTipoTarjeta();
					$('#gridGiros').show();
					habilitaBoton('grabar', 'submit');
					$('#agregaGiros').focus();
					
					if(giroTarDeb.identificacionSocio=='S'){
						mensajeSis('El Tipo de Tarjeta es de Identificación.');
						$('#tipoTarjetaDebID').focus();
						$('#tipoTarjetaDebID').val('');
						$('#nombreTarjeta').val('');
						$('#tipo').val('');
						$('#gridGiros').hide();
						deshabilitaBoton('grabar', 'submit');
					}
				}else  {
					mensajeSis("El Tipo de Tarjeta no Existe");
					$('#tipoTarjetaDebID').focus();
					$('#tipoTarjetaDebID').val('');
					$('#nombreTarjeta').val('');
					$('#tipo').val('');
					$('#gridGiros').hide();
					deshabilitaBoton('grabar', 'submit');
				}
			});			
			}else {
				if ( isNaN(tarjetaDebID )) {
					$('#tipoTarjetaDebID').val('');
					$('#nombreTarjeta').val('');
					$('#gridGiros').hide();
					$('#tipo').val('');
					deshabilitaBoton('grabar', 'submit');
				}
			}
  	}
  	
	function consultagirosTipoTarjeta(){	
		var params = {};
		params['tipoLista'] = 2;
		params['tipoTarjetaDebID'] = $('#tipoTarjetaDebID').val();
		
		$.post("girosTipoTarjetaGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#girosNegocioTipoTarjeta').html(data);
				$('#girosNegocioTipoTarjeta').show();
				agregaFormatoControles('girosNegocioTipoTarjeta');
			}else{	
			
				$('#girosNegocioTipoTarjeta').html("");
				$('#girosNegocioTipoTarjeta').show();
				}
			});
		}
	
	});//	FIN VALIDACIONES DE REPORTES

	var catConsultaGiroNegTipoTarjeta = {
  		'principal'	: 1
	};

	function agregarGirosAceptados(){	
		var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		  
		if(numeroFila == 0){
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" type="hidden" />';
			tds += '<input id="giros'+nuevaFila+'" name="giros"  size="6"  value="" type="hidden" />';								
			tds += '<input type="text" id="giroID'+nuevaFila+'" name="lgiroID" size="5" onkeypress="listaGiros(this.id)" onblur="validaGiroTarjeta(this.id)" /></td>';
			tds += '<td><input  id="descripcion'+nuevaFila+'" name="ldescripcion" size="62" value="" readOnly="true" type="text" /></td>';
		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="'+valor+'" type="hidden" />';
			tds += '<input id="giros'+nuevaFila+'" name="giros"  size="6"  value="" type="hidden" />';								
			tds += '<input type="text" id="giroID'+nuevaFila+'" name="lgiroID" size="5" onkeypress="listaGiros(this.id)" onblur="validaGiroTarjeta(this.id)" /></td>';
			tds += '<td><input  id="descripcion'+nuevaFila+'" name="ldescripcion"  size="62" value="" readOnly="true" type="text" /></td>';	
		}
			tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarGirosAceptados(this.id)"/>';
			tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarGirosAceptados()"/></td>';
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

	function eliminarGirosAceptados(control){	
		var contador = 0 ;
		var numeroID = control;
		
		var jqRenglon = eval("'#renglon" + numeroID + "'");
		var jqNumero = eval("'#consecutivoID" + numeroID + "'");
		var jqGiros = eval("'#giros" + numeroID + "'");		
		var jqGiroID = eval("'#giroID" + numeroID + "'");
		var jqDescripcion=eval("'#descripcion" + numeroID + "'");
		var jqAgrega=eval("'#agrega" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");
	
		// se elimina la fila seleccionada
		$(jqNumero).remove();
		$(jqGiros).remove();
		$(jqGiroID).remove();
		$(jqElimina).remove();
		$(jqDescripcion).remove();
		$(jqAgrega).remove();
		$(jqRenglon).remove();
		//$(jqAgrega).remove();
	
		//Reordenamiento de Controles
		contador = 1;
		var numero= 0;
		$('tr[name=renglon]').each(function() {		
			numero= this.id.substr(7,this.id.length);
			var jqRenglon1 = eval("'#renglon"+numero+"'");
			var jqNumero1 = eval("'#consecutivoID"+numero+"'");
			var jqGiros1 = eval("'#giros"+numero+"'");		
			var jqGiroID1= eval("'#giroID"+numero+"'");
			var jqDescripcion1=eval("'#descripcion"+ numero+"'");
			var jqAgrega1=eval("'#agrega"+ numero+"'");
			var jqElimina1 = eval("'#"+numero+ "'");
		
			$(jqNumero1).attr('id','consecutivoID'+contador);
			$(jqGiros1).attr('id','giros'+contador);
			$(jqGiroID1).attr('id','giroID'+contador);
			listaGiros("giroID" + contador);
			$(jqDescripcion1).attr('id','descripcion'+contador);
			$(jqAgrega1).attr('id','agrega'+contador);
			$(jqElimina1).attr('id',contador);
			$(jqRenglon1).attr('id','renglon'+ contador);
			contador = parseInt(contador + 1);	
			
		});
		
	}
//---------------------------------Funciones Grid de Movimientos-----------------
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
		var jqDescripcion = eval("'#descripcion" + control.substr(6) + "'");
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoTarjetaDeb != '' && !isNaN(tipoTarjetaDeb) && esTab){
			var tipoTarjetaBeanCon = {
				'giroID':tipoTarjetaDeb
			};
			if(verificaSeleccionado(control) == 0){
				giroNegocioTarDebServicio.consulta(catConsultaGiroNegTipoTarjeta.principal,tipoTarjetaBeanCon,function(tipoTarDeb) {
					if(tipoTarDeb!=null){
						$(jqDescripcion).val(tipoTarDeb.descripcion);
					}else{
						mensajeSis("El Número de Giro no Existe");
						$(jq).val("");
						$(jqDescripcion).val("");
						$(jq).focus();
					}
				});
			}
		}else{
			$(jq).val("");
			$(jqDescripcion).val("");
		}
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
				if(valorGiros == nuevoGiro){
					mensajeSis("El Número de Giro ya Existe");
					$('#'+idCampo).focus();
					$('#'+idCampo).val("");
					$('#'+jqDescripcion).val("");
					contador = contador+1;
				}
			}
		});
		return contador;
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
			mensajeSis("Especifique el Número de Giro");
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
	
	function funcionExitoGirosTipoTarjeta (){
		 $('#tipoTarjetaDebID').focus();
		 $('#nombreTarjeta').val('');
		 $('#tipo').val('');
		 $('#gridGiros').hide();
	}
	
	function funcionErrorGirosTipoTarjeta (){
		 $('#tipoTarjetaDebID').focus();
	}