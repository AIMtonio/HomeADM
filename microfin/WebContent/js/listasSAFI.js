
/*=======================================
=            Recorrer Listas            =
=======================================*/

/**
 *
 * numLetrasSAFI - determina el tamaño del texto ingresado en un input
 *             si el tamaño no cambia, no se ejecuta nuevamente la
 *             lista.
 *
 */
var numLetrasSAFI = 0;

/* 
* Ubica el cursor en la primer fila 
* de las opciónes mostradas en la lista
*/
function selectPrimerRegistro(isCaja){
    var encabezado = $('#'+isCaja).find("#encabezadoLista");

    if(encabezado != null){
        encabezado.next().addClass("selected");
    }else{
        $('#'+isCaja).find("tbody").find("tr:first").addClass('selected');
    }

    $('#'+isCaja).scrollTop( 0 );

}


/**
 *
 * Añade las funciones para cambiar la fila seleccionada con las teclas
 * [Arriba] y [Abajo] del teclado.
 * Determina cual es el div que se esta usando para mostrar la lista.
 *
 */
$(document).keydown(function(e){
    if($('#cajaLista').is(":visible")               || 
       $('#cajaListaCte').is(":visible")            || 
       $('#cajaListaContenedor').is(":visible")
       ){

            var idCaja = '';
            $('#cajaLista').is(":visible") ? idCaja = 'cajaLista' : idCaja;
            $('#cajaListaCte').is(":visible") ? idCaja = 'cajaListaCte' : idCaja;
            $('#cajaListaContenedor').is(":visible") ? idCaja = 'cajaListaContenedor' : idCaja;

            var idCampoOrigen = e.target.id;

            var tbody = $('#'+idCaja).find("tbody");
                tbody.find("tr:first");
            var selected = tbody.find(".selected");

            if (e.keyCode == keysSAFI.ENTER) {
                e.preventDefault();
                var selected = $('#'+idCaja).find("tbody").find(".selected");
                $(selected).click();
                $('#'+idCaja).hide();
            }

            if (e.keyCode == keysSAFI.UP) {
                $('#'+idCaja).find(".selected").removeClass("selected");
                if (selected.prev().length == 0) {
                    tbody.find("tr:last").addClass("selected");
                } else {
                    selected.prev().addClass("selected");
                }
            }

            if (e.keyCode == keysSAFI.DOWN) {
                tbody.find(".selected").removeClass("selected");

                if (selected.next().length == 0) {
                    tbody.find("tr:first").addClass("selected");
                } else {
                    selected.next().addClass("selected");
                }
            }


            selected = tbody.find(".selected");
            var ubicaOptionList = selected.position();
            var altoCaja        = $( "#"+idCaja).height();

            

            if(ubicaOptionList!=null){

                if( (ubicaOptionList.top+10)  > altoCaja ||  ubicaOptionList.top < 0 ){
                            $('#'+idCaja).scrollTop( ubicaOptionList.top );
                }
            }
    }
});

