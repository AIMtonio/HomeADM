$(document).ready(function() {
	esTab = true;
	$('#tipoTarjetaDeb').focus();
    $('#tipoTarjetaDeb').attr("checked",false);
    $('#tipoTarjetaCred').attr("checked",false);
    $('#lineaCredito').hide();
	//Definicion de Constantes y Enums
	var catTransaccionGiroTarDeb = {  
		'grabar':'2'
	};
	var catGirosTarjetaIndiv = {
		'giroTarDebInd' :14,
		'giroTarCredInd' :5
	};
	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	$('#gridGiros').hide();
	deshabilitaBoton('grabar', 'submit');
	agregaFormatoControles('formaGenerica');
	
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
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tarjetaID', 
	    			  'funcionExitoGirosTarjetasIndiv','funcionErrorGirosTarjetasIndiv');
	      }
	});
	
	$('#grabar').click(function() {
		
		if($("#tipoTarjetaDeb").is(':checked')) {  
            $('#tipoTransaccion').val(catTransaccionGiroTarDeb.grabar);
			guardarGiros();
			$('#tarjetaID').focus();
        } 
        if($("#tipoTarjetaCred").is(':checked')){
        	$('#tipoTransaccion').val('2'); 
			$('#tarjetaID').focus();
        }
	});	
	
	$('#tarjetaID').blur(function(){
		
		if ($("#tipoTarjetaDeb").is(':checked')){
			consultaTarIndividual();
		}
		else if ($("#tipoTarjetaCred").is(':checked')) {
			consultaTarCredIndividual();
		}
	});	

	$('#tarjetaID').bind('keyup',function(e){ 
		 if(this.value.length >= 2  && isNaN($('#tarjetaID').val())){
		     

		    if($("#tipoTarjetaDeb").is(':checked')) {  
	          lista('tarjetaID', '1', '11','tarjetaDebID', $('#tarjetaID').val(),'tarjetasDevitoLista.htm');
	        } 
	        else if($("#tipoTarjetaCred").is(':checked')){
	        	lista('tarjetaID', '1', '11','tarjetaDebID', $('#tarjetaID').val(),'tarjetasCreditoLista.htm');
	        }
	        else{  
	           mensajeSis("Selecciona el tipo de tarjeta");
	        }

		 }
	});
	
	// ------------ Validaciones de la Forma	
	$('#formaGenerica').validate({
		rules : {
			tarjetaID: {
				required : true,
				maxlength: 16,
				minlength: 16
			}

		},
		messages : {
			tarjetaID:{
				required: 'Especificar el Número de Tarjeta',
				maxlength: 'Maximo 16 caracteres',
				minlength: 'Minimo 16 caracteres'
			}
		}
	});
	
	
	// ------------ Validaciones de Controles-------------------------------------
	function consultaTarIndividual() {
		var tarjetaID =$('#tarjetaID').val();
		var TarjetaDebitoCon = {
			'tarjetaID': $('#tarjetaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if ( tarjetaID != '' && !isNaN(tarjetaID) && esTab) {
			tarDebGirosAcepIndividualServicio.consulta(catGirosTarjetaIndiv.giroTarDebInd, TarjetaDebitoCon,function(giroTarDeb){
			if(giroTarDeb !=null ){
				$('#tarjetaID').val(giroTarDeb.tarjetaID);
				$('#estatus').val(giroTarDeb.estatus);
				$('#clienteID').val(giroTarDeb.clienteID);
				$('#nombreCompleto').val(giroTarDeb.nombreCompleto);
				
				$('#cuentaAho').val(giroTarDeb.cuentaAho);
				$('#nombreTipoCuenta').val(giroTarDeb.nombreTipoCuenta);
				$('#tipoTarjetaID').val(giroTarDeb.tipoTarjetaID);
				$('#nombreTarjeta').val(giroTarDeb.nombreTarjeta);
				
				if (giroTarDeb.coorporativo == '' || giroTarDeb.coorporativo == 0 || giroTarDeb.coorporativo == null) {
					$('#cteCorpTr').hide();
					$('#coorporativo').val('');
				}else {
					$('#cteCorpTr').show();
					$('#coorporativo').val(giroTarDeb.coorporativo);
					consultaTarCoorpo('coorporativo');
				}
				consultagirosTarIndividual();
				$('#gridGiros').show();
				$('#agregaGiros').focus();
				habilitaBoton('grabar', 'submit');
				if(giroTarDeb.identificacionSocio=='S'){
					mensajeSis('El Número de Tarjeta es de Identificación.');
					$('#tarjetaID').focus();
					$('#tarjetaID').val('');
					$('#estatus').val('');
					$('#clienteID').val('');
					$('#nombreCompleto').val('');
					$('#coorporativo').val('');
					$('#cuentaAho').val('');
					$('#nombreTipoCuenta').val('');
					$('#nombreTarjeta').val('');
					$('#tipoTarjetaID').val('');
					$('#nombreTarjeta').val('');
					$('#nombreCoorp').val('');
					$('#gridGiros').hide();	
					deshabilitaBoton('grabar', 'submit');
				}

			}else  {
				mensajeSis("Número de Tarjeta Invalido");
				$('#tarjetaID').focus();
				$('#tarjetaID').val('');
				$('#estatus').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
				$('#cuentaAho').val('');
				$('#nombreTipoCuenta').val('');
				$('#nombreTarjeta').val('');
				$('#tipoTarjetaID').val('');
				$('#nombreTarjeta').val('');
				$('#nombreCoorp').val('');
				$('#gridGiros').hide();				
			}
		});
		}else if(isNaN(tarjetaID)){
			$('#tarjetaID').val('');
			$('#estatus').val('');
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
			$('#coorporativo').val('');
			$('#nombreCoorp').val('');
			$('#cuentaAho').val('');
			$('#nombreTipoCuenta').val('');
			$('#tipoTarjetaID').val('');
			$('#nombreTarjeta').val('');
			$('#gridGiros').hide();
			deshabilitaBoton('grabar', 'submit');
		}
		else if(Number(tarjetaID)== ''){
			$('#tarjetaID').val('');
				$('#estatus').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
				$('#cuentaAho').val('');
				$('#nombreTipoCuenta').val('');
				$('#nombreTarjeta').val('');
				$('#tipoTarjetaID').val('');
	         $('#nombreTarjeta').val('');
				$('#nombreCoorp').val('');
			   $('#gridGiros').hide();
				deshabilitaBoton('grabar', 'submit');
		}
	
	}	





	// ------------ Validaciones de Controles-------------------------------------
	function consultaTarCredIndividual() {
		var tarjetaID =$('#tarjetaID').val();
		var TarjetaCreditoCon = {
			tarjetaID: $('#tarjetaID').val()
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if ( tarjetaID != '' && !isNaN(tarjetaID) && esTab) {
			tarCredGirosAcepIndividualServicio.consulta(catGirosTarjetaIndiv.giroTarCredInd, TarjetaCreditoCon,function(giroTarCred){
			if(giroTarCred !=null && giroTarCred!=''){
				/**/
				$('#tarjetaID').val(giroTarCred.tarjetaID);
				$('#estatus').val(giroTarCred.estatus);
				$('#clienteID').val(giroTarCred.clienteID);
				$('#nombreCompleto').val(giroTarCred.nombreCompleto);
				
				$('#productoID').val(giroTarCred.productoID);
				$('#descripcionProd').val(giroTarCred.descripcionProd);
				$('#tipoTarjetaID').val(giroTarCred.tipoTarjetaID);
				$('#nombreTarjeta').val(giroTarCred.nombreTarjeta);
				
				if (giroTarCred.coorporativo == '' || giroTarCred.coorporativo == 0 || giroTarCred.coorporativo == null) {
					$('#cteCorpTr').hide();
					$('#coorporativo').val('');
				}else {
					$('#cteCorpTr').show();
					$('#coorporativo').val(giroTarCred.coorporativo);
				}
				consultagirosTarCredIndividual();
				$('#gridGiros').show();
				$('#agregaGiros').focus();
				habilitaBoton('grabar', 'submit');
				if(giroTarCred.identificacionSocio=='S'){
					mensajeSis('El Número de Tarjeta es de Identificación.');
					$('#tarjetaID').focus();
					$('#tarjetaID').val('');
					$('#estatus').val('');
					$('#clienteID').val('');
					$('#nombreCompleto').val('');
					$('#coorporativo').val('');
					$('#productoID').val('');
					$('#descripcionProd').val('');
					$('#nombreTarjeta').val('');
					$('#tipoTarjetaID').val('');
					$('#nombreTarjeta').val('');
					$('#nombreCoorp').val('');
					$('#gridGiros').hide();	
					deshabilitaBoton('grabar', 'submit');
				}
				

			}else  {
				mensajeSis("Número de Tarjeta Invalido");
				$('#tarjetaID').focus();
				$('#tarjetaID').val('');
				$('#estatus').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
				$('#productoID').val('');
				$('#descripcionProd').val('');
				$('#nombreTarjeta').val('');
				$('#tipoTarjetaID').val('');
				$('#nombreTarjeta').val('');
				$('#nombreCoorp').val('');
				$('#gridGiros').hide();		
			}
		});
		}else if(isNaN(tarjetaID)){
			console.log('null');
			/**/
			$('#tarjetaID').val('');
			$('#estatus').val('');
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
			$('#coorporativo').val('');
			$('#nombreCoorp').val('');
			$('#productoID').val('');
			$('#descripcionProd').val('');
			$('#tipoTarjetaID').val('');
			$('#nombreTarjeta').val('');
			$('#gridGiros').hide();
			deshabilitaBoton('grabar', 'submit');
			
		}
		else if(Number(tarjetaID)== ''){
			console.log('number');
				$('#tarjetaID').val('');
				$('#estatus').val('');
				$('#clienteID').val('');
				$('#nombreCompleto').val('');
				$('#coorporativo').val('');
				$('#productoID').val('');
				$('#descripcionProd').val('');
				$('#nombreTarjeta').val('');
				$('#tipoTarjetaID').val('');
	         	$('#nombreTarjeta').val('');
				$('#nombreCoorp').val('');
			   $('#gridGiros').hide();
				deshabilitaBoton('grabar', 'submit');
			
		}
	
	}	









	function consultaTarCoorpo(idControl) {
		var jqCoorpo = eval("'#" + idControl + "'");
		var coorporativo = $(jqCoorpo).val();
		var consulTarCoorpo = 12;
		setTimeout("$('#cajaLista').hide();", 200);
		if (  Number(coorporativo)>0  && !isNaN(coorporativo) ) {
			clienteServicio.consulta(consulTarCoorpo, coorporativo,"",function(cliente) {
				if (cliente != null) {
				
					$('#coorporativo').val(cliente.numero);
					$('#nombreCoorp').val(cliente.nombreCompleto);
				} else {
					mensajeSis("No Existe el Corporativo relacionado.");
					$('#coorporativo').val('');
					$('#nombreCoorp').val('');
				}
			});
		}else{
			$('#coorporativo').val('');
			$('#nombreCoorp').val('');
		}
	}

	function consultagirosTarIndividual(){	
		var params = {};
		params['tipoLista'] = 2;
		params['tarjetaID'] = $('#tarjetaID').val();
		
		$.post("girosTarjetasIndividualGridVista.htm", params, function(data){
			if(data.length >0) {		
				$('#girosTarjetasIndividual').html(data);
				$('#girosTarjetasIndividual').show();
				agregaFormatoControles('girosTarjetasIndividual');
			}else{	
			
				$('#girosTarjetasIndividual').html("");
				$('#girosTarjetasIndividual').show();
			}
		});
	}


function consultagirosTarCredIndividual(){	
		var params = {};
		params['tipoLista'] = 2;
		params['tarjetaID'] = $('#tarjetaID').val();
		
		$.post("girosTarjetasCredIndividualGridVista.htm", params, function(data){
				
			if(data.length >0) {		
				$('#girosTarjetasIndividual').html(data);
				$('#girosTarjetasIndividual').show();
				agregaFormatoControles('girosTarjetasIndividual');
			}else{	
			
				$('#girosTarjetasIndividual').html("");
				$('#girosTarjetasIndividual').show();
			}
		});
	}	
	
});//	FIN VALIDACIONES DE REPORTES

	var catTipoConsultaGiroNeg = {
  		'principal'	: 1
	};

	function agregarGirosAceptados(){	
		var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		  
		if(numeroFila == 0){
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
			tds += '<input id="giros'+nuevaFila+'" name="giros"  size="6"  value="" autocomplete="off"  type="hidden" />';								
			tds += '<input type="text" id="giroID'+nuevaFila+'" name="lgiroID" size="5" onkeypress="listaGiros(this.id)" onblur="validaGiroTarjeta(this.id)" /></td>';
			tds += '<td><input  id="descripcion'+nuevaFila+'" name="ldescripcion"  size="62" value="" readOnly="true" type="text" /></td>';			
		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="'+valor+'"autocomplete="off"  type="hidden" />';
			tds += '<input id="giros'+nuevaFila+'" name="giros"  size="6"  value="" autocomplete="off" type="hidden" />';								
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
			giroNegocioTarDebServicio.consulta(catTipoConsultaGiroNeg.principal,tipoTarjetaBeanCon,function(tipoTarDeb) {
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
	

	function lipiaCampos() {
		$('#tarjetaID').val('');
		$('#estatus').val('');
		$('#clienteID').val('');
		$('#nombreCompleto').val('');
		$('#coorporativo').val('');
		$('#cuentaAho').val('');
		$('#nombreTipoCuenta').val('');
		$('#nombreTarjeta').val('');
		$('#tipoTarjetaID').val('');
		$('#nombreTarjeta').val('');
		$('#nombreCoorp').val('');
		$('#gridGiros').hide();	
	}
	$('#tipoTarjetaDeb').click(function() {	
		lipiaCampos();
		$('#tipoTarjetaCred').attr("checked",false);
		$('#tipoTarjeta').val('1');
		$('#tarjetaID').focus();
		$('#cuentaAhorro').show();
		$('#lineaCredito').hide();

		

		
	});
	$('#tipoTarjetaCred').click(function() {
		lipiaCampos();	
		$('#tipoTarjetaDeb').attr("checked",false);
		$('#tipoTarjeta').val('2');
		$('#tarjetaID').focus();
		$('#cuentaAhorro').hide();
		$('#lineaCredito').show();

		
	});
		
	function funcionExitoGirosTarjetasIndiv (){
		 $('#tarjetaID').focus();
		 $('#estatus').val('');
		 $('#clienteID').val('');
		 $('#nombreCompleto').val('');
		 $('#coorporativo').val('');
		 $('#nombreCoorp').val('');
		 $('#montoComDia').val('');
		 $('#cuentaAho').val('');
		 $('#nombreTipoCuenta').val('');
		 $('#tipoTarjetaID').val('');
		 $('#nombreTarjeta').val('');
		 $('#productoID').val('');
		 $('#descripcionProd').val('');
		 $('#gridGiros').hide();
	}
	
	function funcionErrorGirosTarjetasIndiv (){
		 $('#tarjetaID').focus();
	}