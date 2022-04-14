package tarjetas.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import tarjetas.bean.TarDebBitacoraMovsBean;
import tarjetas.dao.TarDebBitacoraMovsDAO;

public class TarDebBitacoraMovsServicio extends BaseServicio {
	
	TarDebBitacoraMovsDAO tarDebBitacoraMovsDAO = null;
	public TarDebBitacoraMovsServicio(){
		super();
	}
	public static interface Enum_Tra_Checkin{
		int procesaCheckin =1;
	}
	
	public static interface Enum_Con_Checkin{
		int checkin =3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(TarDebBitacoraMovsBean tarDebBitacoraMovsBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String cadena = "";
		String[] cadenaSplit;
		int fallidos = 0;
		int exitosos = 0;
		
		if( tarDebBitacoraMovsBean.getListTransaccCheckout() != null ){
			List<String> listaCheckout = tarDebBitacoraMovsBean.getListTransaccCheckout();
			if(!listaCheckout.isEmpty()){
				for(int i=0; i<listaCheckout.size(); i++){
					cadena = listaCheckout.get(i);
					TarDebBitacoraMovsBean tarDebBitacoraMovs = new TarDebBitacoraMovsBean();					
					if (!cadena.isEmpty()){
						cadenaSplit = cadena.split("&");						
						tarDebBitacoraMovs.setNumtarjeta(cadenaSplit[0]);						
						tarDebBitacoraMovs.setNumCta(cadenaSplit[1]);						
						tarDebBitacoraMovs.setOperacion(cadenaSplit[2]);
						tarDebBitacoraMovs.setUbicaTerminal(cadenaSplit[3]);
						tarDebBitacoraMovs.setMontoTransac(cadenaSplit[4]);
						tarDebBitacoraMovs.setTipoMensaje(cadenaSplit[5]);
						tarDebBitacoraMovs.setOrigenInst(cadenaSplit[6]);
						tarDebBitacoraMovs.setGiroNegocio(cadenaSplit[7]);					
						tarDebBitacoraMovs.setCheckIn(cadenaSplit[8]);
						tarDebBitacoraMovs.setCodigoAprobacion(cadenaSplit[9]);
						tarDebBitacoraMovs.setFechaSistema(cadenaSplit[10]);
						tarDebBitacoraMovs.setCodigoMonOpe(cadenaSplit[11]);					
						tarDebBitacoraMovs.setPuntoEntrada(cadenaSplit[12]);
						tarDebBitacoraMovs.setReferencia(cadenaSplit[13]);
						tarDebBitacoraMovs.setEsIsotrx(cadenaSplit[14]);
						tarDebBitacoraMovs.setTarDebMovID(cadenaSplit[15]);
						
						//Cuando es una operacion normal de SAFI
						if(tarDebBitacoraMovs.getEsIsotrx().equals("N")) {
							mensaje = tarDebBitacoraMovsDAO.procesaCheckin( tarDebBitacoraMovs, Enum_Tra_Checkin.procesaCheckin);
							
							if(mensaje.getNumero() == Constantes.ENTERO_CERO){
								exitosos ++;
							}else{
								fallidos ++;
							}	
						}
						//CUANDO ES UNA OPERACION DE ISOTRX
						if(tarDebBitacoraMovs.getEsIsotrx().equals("S")) {
							int consultaIsotrx = 1;
							tarDebBitacoraMovs = tarDebBitacoraMovsDAO.consultaMovsIsotrx(tarDebBitacoraMovs, consultaIsotrx);
							
							mensaje = tarDebBitacoraMovsDAO.procesaTransaccionReporte(tarDebBitacoraMovs);
							
							if(mensaje.getNumero() == Constantes.ENTERO_CERO){
								exitosos ++;
							}else{
								fallidos ++;
							}	
						}
					}
			}
				
		}
	}
		mensaje.setNumero(Constantes.ENTERO_CERO);
		mensaje.setDescripcion("Transacciones Exitosas: "+ exitosos +"<br>"+"Transacciones Fallidas:   "+ fallidos );
		mensaje.setNombreControl("SaldoDisponibleAct");		
		mensaje.setConsecutivoInt(Constantes.STRING_CERO);
				
		return mensaje;
	}
	
	
	public  Object[] listaConsulta(int tipoConsulta){		
		List listCheckin = null;
		switch(tipoConsulta){
			case Enum_Con_Checkin.checkin:
				listCheckin = tarDebBitacoraMovsDAO.consultaCheckin( tipoConsulta);
			break;
		
		}
		return listCheckin.toArray();
	}
	
	public TarDebBitacoraMovsDAO getTarDebBitacoraMovsDAO() {
		return tarDebBitacoraMovsDAO;
	}
	public void setTarDebBitacoraMovsDAO(TarDebBitacoraMovsDAO tarDebBitacoraMovsDAO) {
		this.tarDebBitacoraMovsDAO = tarDebBitacoraMovsDAO;
	}
	
}