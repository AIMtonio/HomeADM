$(document).ready(function() {
	

	esTab = true;
	
	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	//Definicion de Constantes y Enums  
	var tipoTransaccion = {  
			'grabar':'1'
	};

	//------------ Msetodos y Manejo de Eventos -----------------------------------------
	
	deshabilitaBoton('grabar', 'submit');
	habilitaBoton('agregarImpuesto','submit');
	$("#tipoProveedorID").focus();
	agregaFormatoControles('formaGenerica');

	
	


	$.validator.setDefaults({
		submitHandler: function(event) {
			var envia = guardarParametros();
			if(envia!=2){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoProveedorID',
			'funcionExitoImpuestosProveedor','funcionErrorImpuestosProveedor');
			}
			else{
				mensajeSis("Faltan Datos");
			}
		}
	});	

	
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.grabar);
	});
	
	

	$('#tipoProveedorID').bind('keyup',function(e) {
			lista('tipoProveedorID', '2', '1', 'descripcion', $('#tipoProveedorID').val(), 'listaTipoProveedores.htm');
		
	});
	
  	$('#tipoProveedorID').blur(function() {   	
  		if($('#tipoProveedorID').val()!="" && esTab == true){
  		consultaImpuestosProveedor($('#tipoProveedorID').val()); 
  		consultaTipoProveedor($('#tipoProveedorID').val());
  		}
   	});
	//------------ Validaciones de la Forma -------------------------------------
  	
	$('#formaGenerica').validate({

		rules: {
			tipoProveedorID:{
				required : true
				//numeroPositivo: true
			}

		},		
		messages: {		
			tipoProveedorID : {
				required : 'Específique el Tipo de Proveedor'
			}

		}		
	});
});


	//------------ Validaciones de Controles -------------------------------------
	function consultaImpuestosProveedor(numTipoProveedor){	
		var numTipoProveedor = $('#tipoProveedorID').val();
		numTipoProveedor != ''?numTipoProveedor = numTipoProveedor : numTipoProveedor=0; 
		var params = {};
		params['tipoLista'] = 3;
		params['tipoProveedorID'] = numTipoProveedor;

		$.post("impuestosProveedorGridVista.htm", params, function(data){
			if(data.length >0 && $('#tipoProveedorID').val()!=''&& $('#tipoProveedorID').val()!=0) {
				$('#divImpuestosProveedor').html(data);
				$('#divImpuestosProveedor').show();
				agregaFormatoTasa('formaGenerica');

			}else{	
			
				$('#divImpuestosProveedor').html("");
				$('#divImpuestosProveedor').show();
				
				}
			});
		}
	
	function agregarImpuestos(){
		var numProv=$('#tipoProveedorID').val();
		var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		if(numeroFila == 0){
			tds += '<td align="center"><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" type="hidden" />';
			tds += '<input type="text" id="tipoProveedorID'+nuevaFila+'" name="ltipoProveedorID"  size="10"  value='+numProv+' readOnly="true"/></td>';								
			tds += '<td align="center"><input type="text" id="impuestoID'+nuevaFila+'" name="limpuestoID" size="10" value="" onkeypress="listaImpuesto(this.id)" onblur="validaImpuesto(this.id,\'tipoProveedorID'+numeroFila+'\');" /></td>';
			tds += '<td align="center"><input type="text" id="descripCorta'+nuevaFila+'" name="ldescripCorta" size="30" value="" disabled="true"/></td>';
			tds += '<td align="center"><input type="text" id="tasa'+nuevaFila+'" name="ltasa" size="10" value="" esTasa="true" disabled="true" style="text-align:right;"/></td>';
			tds += '<td align="center"><input type="text" id="orden'+nuevaFila+'" name="lorden" size="10" value="" onblur="verificaOrden(this.id);"  onkeyPress="return validador(event);"/></td>';
		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td align="center"><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="'+valor+'" type="hidden" />';
			tds += '<input type="text" id="tipoProveedorID'+nuevaFila+'" name="ltipoProveedorID"  size="10"  value='+numProv+' readOnly="true"/></td>';								
			tds += '<td align="center"><input type="text" id="impuestoID'+nuevaFila+'" name="limpuestoID" size="10" value="" onkeypress="listaImpuesto(this.id)" onblur="validaImpuesto(this.id,\'tipoProveedorID'+numeroFila+'\');"/></td>';
			tds += '<td align="center"><input type="text" id="descripCorta'+nuevaFila+'" name="ldescripCorta" size="30" value="" disabled="true"/></td>';
			tds += '<td align="center"><input type="text" id="tasa'+nuevaFila+'" name="ltasa" size="10" value=""esTasa="true" disabled="true" style="text-align:right;"/></td>';
			tds += '<td align="center"><input type="text" id="orden'+nuevaFila+'" name="lorden" size="10" value="" onblur="verificaOrden(this.id);" onkeyPress="return validador(event);"/></td>';
		}
			tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarImpuestos(this.id)"  />';
			tds += '	 <input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarImpuestos()"/></td>';
			tds += '</tr>';	   	   
			$("#miTabla").append(tds);
			var jqRenglon = eval("'#tipoProveedorID" + nuevaFila + "'");
			$(jqRenglon).focus();
			return false;	
			
			
		}

	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;		
		});
		return totales;
	}
	
	
	function eliminarImpuestos(control){	
		var contador = 0 ;
		var numeroID = control;
		
		var jqRenglon = eval("'#renglon" + numeroID + "'");
		var jqNumero = eval("'#consecutivoID" + numeroID + "'");
		var jqTipoProveedorID = eval("'#tipoProveedorID" + numeroID + "'");		
		var jqImpuestoID = eval("'#impuestoID" + numeroID + "'");
		var jqDescripCorta=eval("'#descripCorta" + numeroID + "'");
		var jqTasa = eval("'#tasa" + numeroID + "'");
		var jqOrden=eval("'#orden" + numeroID + "'");
		var jqAgrega=eval("'#agrega" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");
	
		// se elimina la fila seleccionada
		$(jqNumero).remove();
		$(jqTipoProveedorID).remove();
		$(jqImpuestoID).remove();
		$(jqElimina).remove();
		$(jqDescripCorta).remove();
		$(jqTasa).remove();
		$(jqOrden).remove();
		$(jqAgrega).remove();
		$(jqRenglon).remove();
	
		//Reordenamiento de Controles
		contador = 1;
		var numero= 0;
		$('tr[name=renglon]').each(function() {		
			numero= this.id.substr(7,this.id.length);
			var jqRenglon1 = eval("'#renglon"+numero+"'");
			var jqNumero1 = eval("'#consecutivoID"+numero+"'");
			var jqTipoProveedorID1 = eval("'#tipoProveedorID"+numero+"'");		
			var jqImpuestoID1= eval("'#impuestoID"+numero+"'");
			var jqDescripCorta1=eval("'#descripCorta"+ numero+"'");
			var jqTasa1=eval("'#tasa"+ numero+"'");
			var jqOrden1=eval("'#orden"+ numero+"'");
			var jqAgrega1=eval("'#agrega"+ numero+"'");
			var jqElimina1 = eval("'#"+numero+ "'");
		
			$(jqNumero1).attr('id','consecutivoID'+contador);
			$(jqTipoProveedorID1).attr('id','tipoProveedorID'+contador);
			$(jqImpuestoID1).attr('id','impuestoID'+contador);
			$(jqDescripCorta1).attr('id','descripCorta'+contador);
			$(jqTasa1).attr('id','tasa'+contador);
			$(jqOrden1).attr('id','orden'+contador);
			$(jqAgrega1).attr('id','agrega'+contador);
			$(jqElimina1).attr('id',contador);
			$(jqRenglon1).attr('id','renglon'+ contador);
			contador = parseInt(contador + 1);	
			
		});
		
	}
		
	
	function listaImpuesto(idControl){
		var jq = eval("'#" + idControl + "'");
		$(jq).bind('keyup',function(e){
			var jqControl = eval("'#" + this.id + "'");
			var num = $(jqControl).val();
				
			var camposLista = new Array();
			var parametrosLista = new Array();	
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = num;
			lista(idControl, '1', '2', camposLista, parametrosLista, 'listaImpuestos.htm');
		});
	}


	function validaImpuesto(control,tipoProveedor) {
		var TipoConsulta = 3;
		var jq = eval("'#" + control + "'");
		var numImpuesto = $(jq).val();
		var ImpuestosCon = {
				'impuestoID': numImpuesto
		};
		var jqDescripCorta = eval("'#descripCorta" + control.substr(10) + "'");
		var jqTasa = eval("'#tasa" + control.substr(10) + "'");
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true;
		if(numImpuesto != '' && !isNaN(numImpuesto)&& esTab){
			impuestoServicio.consulta(TipoConsulta,ImpuestosCon,function(impuestos) {
					if(impuestos!=null){
						$(jqDescripCorta).val(impuestos.descripCorta);
						$(jqTasa).val(impuestos.tasa);
						$(jqTasa).formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 4
						});
						verificaProveeImp(control,tipoProveedor);
					}else{
						mensajeSis("No Existe el Impuesto");
						$(jq).val("");
						$(jq).focus();
						$(jqDescripCorta).val("");
						$(jqTasa).val("");
						
					}

				});
			}
		}
	
	
	
	function consultaTipoProveedor(control) {
		var numTipoProveedor = $('#tipoProveedorID').val();
			var conPrincipal = 1;
			var TipoProveedorBeanCon = {
					'tipoProveedorID': numTipoProveedor
			};
				//////////consulta de tipo proveedores/////////////////////////////	
			if(numTipoProveedor != '' && !isNaN(numTipoProveedor)&& esTab){
				tipoProvServicio.consultaPrincipal(conPrincipal,TipoProveedorBeanCon,function(tipoProveedor) {
					if(tipoProveedor!=null){
						$('#descripcion').val(tipoProveedor.descripcion);
						$('#agregarImpuesto').show();
						habilitaBoton('grabar','submit');
						}else{
						mensajeSis("No Existe el Tipo de Proveedor");
						$('#descripcion').val('');
						$('#tipoProveedorID').focus();
						$('#tipoProveedorID').val('');	
						$('#agregarImpuesto').hide();
						deshabilitaBoton('grabar','submit');

					}
				});
				
			}

		
	}
	function onblurOrden(idControl) {
		var orden= $('#'+idControl).val(); 
		if(orden == 0){
			mensajeSis("La cantidad debe ser mayor a 0");
			$("#"+ idControl).focus();
			}

	}

	function validador(e){
		key=(document.all) ? e.keyCode : e.which;
		if (key < 48 || key > 57){
			if (key==8 || key == 0){
				return true;
			}
			else 
	  		return false;
		}
	}
	
	
	// Función para validar que no exista campos vacios al grabar lo impuestos
	function guardarParametros(){		
		var mandar = verificarvacios();
		if(mandar!=1){   		  		
		var numCodigo = $('input[name=consecutivoID]').length;
		$('#datosGrid').val("");
		for(var i = 1; i <= numCodigo; i++){
			if(i == 1){
				$('#datosGrid').val($('#datosGrid').val() +
						document.getElementById("impuestoID"+i+"").value + ']' +
						document.getElementById("orden"+i+"").value);
				return 1;
			}else{
				$('#datosGrid').val($('#datosGrid').val() + '[' +
						document.getElementById("impuestoID"+i+"").value + ']' +
						document.getElementById("orden"+i+"").value);	
				return 1;
				}	
			}
		}
		else{
		return 2;
		}
	}
	
	function verificarvacios(){
		quitaFormatoControles('datosGrid');
		var numCodig = $('input[name=consecutivoID]').length;
		
		$('#divImpuestosProveedor').val("");
		for(var i = 1; i <= numCodig; i++){
			var idimpuestoID = document.getElementById("impuestoID"+i+"").value;
			if (idimpuestoID ==""){
				document.getElementById("impuestoID"+i+"").focus();
				$(idimpuestoID).addClass("error");
				return 1;
			}
			var idorden = document.getElementById("orden"+i+"").value;
			if (idorden ==""){
				document.getElementById("orden"+i+"").focus();
				$(idorden).addClass("error");
				return 1;
			}
		}
	}
		
	// el proveedor y el impuesto no sean iguales
	function verificaProveeImp(idImp,idCampo){
		var contador = 0;
		var nuevoProv=$('#'+idCampo).val();
		var nuevoImp=$('#'+idImp).val();
		var id= idImp.substr(10,idImp.length);
		var nombreImp = eval("'descripCorta" + id+ "'");
		var tasa = eval("'tasa" + id+ "'");
			$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqIdProv = eval("'tipoProveedorID" + numero+ "'");		
			var jqNuevoImp = eval("'impuestoID" + numero+ "'");
			var valorProv = $('#'+jqIdProv).val();
			var valorImp = $('#'+jqNuevoImp).val();
			
			if(id != numero){
				if((valorProv == nuevoProv) && (valorImp == nuevoImp)){
					mensajeSis("El registro ya existe");
					$('#'+idImp).focus();
					$('#'+idImp).val("");
					$('#'+nombreImp).val("");
					$('#'+tasa).val("");
					contador = contador+1;
				}
			}
		});
		return contador;
	}
	
	// el mismo orden no se capture dos veces
	function verificaOrden(idOrden){
		var contador = 0;
		var nuevoOrden=$('#'+idOrden).val();
		var id= idOrden.substr(5,idOrden.length);
			$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqNuevoOrden = eval("'orden" + numero+ "'");		
			var valorOrden = $('#'+jqNuevoOrden).val();
			
			if(id != numero){
				if((valorOrden == nuevoOrden)){
					mensajeSis("El número de orden ya existe");
					$('#'+idOrden).focus();
					$('#'+idOrden).val("");
					contador = contador+1;
				}
			}
		});
		return contador;
	}
	
	
	function funcionExitoImpuestosProveedor (){
		 $('#agregarImpuesto').focus();
		 $('#divImpuestosProveedor').hide();
		deshabilitaBoton('grabar','submit');
		$("#tipoProveedorID").focus();

	}
	
	function funcionErrorImpuestosProveedor (){
		$('#agregarImpuesto').focus();
		deshabilitaBoton('grabar','submit');
	}
	
	

	
