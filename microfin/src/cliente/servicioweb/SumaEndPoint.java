package cliente.servicioweb;
/*COMENTARIO*/
import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import cliente.BeanWS.Request.Sumandos;
import cliente.BeanWS.Response.Resultado;

public class SumaEndPoint extends AbstractMarshallingPayloadEndpoint {

    public SumaEndPoint(Marshaller marshaller){
        super(marshaller);
    
    }

    protected Object invokeInternal(Object sm) throws Exception {
    	
        Sumandos sumandos = new Sumandos();
        Resultado resultado = new Resultado();
        
        sumandos = (Sumandos) sm;

        resultado.setResultado(sumandos.getSumando1() + sumandos.getSumando2());

        return resultado;
    }
}
