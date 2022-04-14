var parametroBean = consultaParametrosSession();

$(document).ready(function () {
    // Definicion de Constantes y Enums
    esTab = true;

    //------------ Metodos y Manejo de Eventos -----------------------------------------
    agregaFormatoControles("formaGenerica");
    $("#fechaInicial").val(parametroBean.fechaSucursal);
    $("#fechaFinal").val(parametroBean.fechaSucursal);
    $("#excel").attr("checked", true);
    $('#remesaCatalogoID').val('0');
    $('#nombre').val('TODOS');

    $(":text").focus(function () {
        esTab = false;
    });
    $(":text").bind("keydown", function (e) {
        if (e.which == 9 && !e.shiftKey) {
        esTab = true;
        }
    });

	$('#remesaCatalogoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombre";
		parametrosLista[0] = $('#remesaCatalogoID').val();
		listaAlfanumerica('remesaCatalogoID', '1', '1', camposLista, parametrosLista, 'listaCatalogoRemesadora.htm');
	});

    $('#remesaCatalogoID').blur(function(){
        consultaRemesaCatalogoID();

	});



    $("#fechaInicial").blur(function () {
        var Xfecha = $("#fechaInicial").val();
        if (esFechaValida(Xfecha)) {
            if (Xfecha == "") $("#fechaInicial").val(parametroBean.fechaSucursal);
                var Yfecha = $("#fechaFinal").val();
                if (Yfecha != "") {
                    if (mayor(Xfecha, Yfecha)) {
                    	mensajeSis("La Fecha Inicial es mayor a la Fecha Final.");
                        $("#fechaInicial").val(parametroBean.fechaSucursal);
                    }
                }
        } else {
            $("#fechaInicial").val(parametroBean.fechaSucursal);

        }
    });

    $("#fechaInicial").change(function () {
        var Xfecha = $("#fechaInicial").val();
        if (esFechaValida(Xfecha)) {
            if (Xfecha == "") $("#fechaInicial").val(parametroBean.fechaSucursal);
                var Yfecha = $("#fechaFinal").val();
                if (Yfecha != "") {
                    if (mayor(Xfecha, Yfecha)) {
                    	mensajeSis("La Fecha Inicial es mayor a la Fecha Final.");
                        $("#fechaInicial").val(parametroBean.fechaSucursal);
                    }
                }
        } else {
            $("#fechaInicial").val(parametroBean.fechaSucursal);
        }
    });

    $("#fechaFinal").blur(function () {
        var Xfecha = $("#fechaInicial").val();
        var Yfecha = $("#fechaFinal").val();
        if (esFechaValida(Yfecha)) {
            if (Yfecha == "") $("#fechaFinal").val(parametroBean.fechaSucursal);
                if (mayor(Xfecha, Yfecha)) {
                	mensajeSis("La Fecha Inicial es mayor a la Fecha Final.");
                    $("#fechaFinal").val(Xfecha);
                }
        } else {
            $("#fechaFinal").val(parametroBean.fechaSucursal);
        }
    });

    $("#fechaFinal").change(function () {
        var Xfecha = $("#fechaInicial").val();
        var Yfecha = $("#fechaFinal").val();
        if (esFechaValida(Yfecha)) {
            if (Yfecha == "") $("#fechaFinal").val(parametroBean.fechaSucursal);
                if (mayor(Xfecha, Yfecha)) {
                	mensajeSis("La Fecha Inicial es mayor a la Fecha Final.");
                    $("#fechaFinal").val(Xfecha);
                }
        } else {
            $("#fechaFinal").val(parametroBean.fechaSucursal);
        }
    });

    $("#generar").click(function() {
        generaReporte();
    });


});

function limpiaCampos() {
    $("#fechaInicial").val(parametroBean.fechaSucursal);
    $("#fechaFinal").val(parametroBean.fechaSucursal);
    $("#fechaInicial").focus();
    $('#remesaCatalogoID').val('0');
    $('#nombre').val('TODOS');
}

/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha) {
    if (fecha != undefined && fecha.value != "") {
        var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
        if (!objRegExp.test(fecha)) {
        	mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd)");
            return false;
        }
        var mes = fecha.substring(5, 7) * 1;
        var dia = fecha.substring(8, 10) * 1;
        var anio = fecha.substring(0, 4) * 1;
        switch (mes) {
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12:
                numDias = 31;
                break;
            case 4:
            case 6:
            case 9:
            case 11:
                numDias = 30;
                break;
            case 2:
                if (comprobarSiBisisesto(anio)) {
                numDias = 29;
                } else {
                numDias = 28;
                }
                break;
            default:
                mensajeSis("Fecha introducida erróneamente");
                return false;
        }
        if (dia > numDias || dia == 0) {
        	mensajeSis("Fecha introducida erróneamente");
            return false;
        }
        return true;
    }
}

function comprobarSiBisisesto(anio) {
    if (anio % 100 != 0 && (anio % 4 == 0 || anio % 400 == 0)) {
        return true;
    } else {
        return false;
    }
}

function mayor(fecha, fecha2) {
    //0|1|2|3|4|5|6|7|8|9|
    //2 0 1 2 / 1 1 / 2 0
    var xMes = fecha.substring(5, 7);
    var xDia = fecha.substring(8, 10);
    var xAnio = fecha.substring(0, 4);

    var yMes = fecha2.substring(5, 7);
    var yDia = fecha2.substring(8, 10);
    var yAnio = fecha2.substring(0, 4);

    if (xAnio > yAnio) {
        return true;
    } else {
        if (xAnio == yAnio) {
            if (xMes > yMes) {
                return true;
            }
            if (xMes == yMes) {
                if (xDia > yDia) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
}

/* Función para generar el reporte de operaciones con remesas en formato Excel*/
function generaReporte() {
    var fechaInicial = $("#fechaInicial").val();
    var fechaFinal = $("#fechaFinal").val();
    var entidad = $('#remesaCatalogoID').val();
    var nombreEntidad = $('#nombre').val();
    var tipoOperacion = $("#tipoOperacion").asNumber();
    var estatus = $("#estatus").asNumber();
    var umbral = $("#umbral").asNumber();

    if(validarFechaSistema(fechaInicial, fechaFinal)){
        mensajeSis("La Fecha Inicial y/o Final No Pueden Ser Mayores que la del Sistema.");
        $("#fechaInicial").val(parametroBean.fechaSucursal);
        $("#fechaFinal").val(parametroBean.fechaSucursal);
    }
    else{
        if  (entidad !== ''){
            if(esNumero(entidad)){
                var pagina='repOperacionesRemesas.htm?fechaInicial='+fechaInicial+'&fechaFinal='+fechaFinal+
                '&entidadTDE='+entidad+'&tipoOperacion='+tipoOperacion+'&estatus='+estatus+'&umbral='+umbral+'&nombreEnt='+nombreEntidad;
                window.open(pagina, "_blank");
            }
            else{
                mensajeSis("Por Favor, Ingrese solo Números en el campo de la Entidad.");
                $('#remesaCatalogoID').focus();
                $('#remesaCatalogoID').val("0");
                $('#nombre').val("TODOS");
            }
        }
        else{
            mensajeSis("La Entidad TD o TDE no puede estar vacía.");
            $('#remesaCatalogoID').focus();
            $('#remesaCatalogoID').val("0");
            $('#nombre').val("TODOS");
        }
    }
}

// Función que verifica que las fechas de inicio o final no sean mayores a la del sistema
function validarFechaSistema(fechaX, fechaY){
    var fechaSistema = parametroBean.fechaSucursal;
    if(fechaX > fechaSistema){
        return true;
    }
    else{
        if(fechaY > fechaSistema){
            return true;
        }
        else{
            return false;
        }
    }
}

// Funcion para consultar si existe la remesedora
function consultaRemesaCatalogoID(){
    var numRemesa = $('#remesaCatalogoID').val();
    //setTimeout("$('#cajaLista').hide();", 200);

    if(numRemesa != '' && !isNaN(numRemesa) && esTab){
        if(numRemesa == '0'){
            $('#remesaCatalogoID').val('0');
            $('#nombre').val('TODOS');
        }
        else{
            var bean= {
                'remesaCatalogoID':$('#remesaCatalogoID').val()
            };
            //catalogoRemesasServicio.consulta(1,numRemesa);
            catalogoRemesasServicio.consulta(1,bean,function(CatRemesaBeanResp) {
                if(CatRemesaBeanResp == null){
                    mensajeSis('La Entidad TD o TDE No Existe.');
                    $('#remesaCatalogoID').focus();
                    $('#remesaCatalogoID').val('0');
                    $('#nombre').val('TODOS');
                }
                else{
                    $('#nombre').val(CatRemesaBeanResp.nombreCorto);
                }
            });
        }
    }
}

// Función para verificar que si son números lo que se ingresa en el input
function esNumero (valor){
    var valoresAceptados = /^[0-9]+$/;// Solo números
    if (valor.indexOf(".") === -1 ){
        if (valor.match(valoresAceptados)){
           return true;
        }else{
           return false;
        }
    }else{
        //dividir la expresión por el punto en un array
        var particion = valor.split(".");
        //evaluamos la primera parte de la división (parte entera)
        if (particion[0].match(valoresAceptados) || particion[0]== ""){
            if (particion[1].match(valoresAceptados)){
                return true;
            }else {
                return false;
            }
        }else{
            return false;
        }
    }
}