package credito.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.CalPorRangoBean;
import credito.dao.CalPorRangoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CalPorRangoServicio extends BaseServicio{
	CalPorRangoDAO calPorRangoDAO = null;
	
	public static interface Enum_Tra_CalifRango {
		int alta = 1;
	}
	public static interface Enum_Lis_CalifRango{
		int califRango= 3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CalPorRangoBean calPorRangoBean, 
			String limInferiores, String limSuperiores, String califica ){
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_CalifRango.alta:
				mensaje = altaReservaDias(calPorRangoBean, limInferiores, limSuperiores, califica);
			break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean altaReservaDias(CalPorRangoBean calPorRangoBean, String limInferiores, String limSuperiores, String califica){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaCalifReserva = (ArrayList) creaListaCalifRango(calPorRangoBean, limInferiores, limSuperiores, califica);
		mensaje = calPorRangoDAO.grabaListaCalifRango(calPorRangoBean, listaCalifReserva );
		return mensaje;
	}

	private List creaListaCalifRango(CalPorRangoBean calPorRangoBean, String limInferiores,	 String limSuperiores, String califica){
		StringTokenizer tokensInferior = new StringTokenizer(limInferiores, ",");
		StringTokenizer tokensSuperior = new StringTokenizer(limSuperiores, ",");
		StringTokenizer tokensCalifica = new StringTokenizer(califica, ",");

		ArrayList listaDias = new ArrayList();
		CalPorRangoBean califRango;

		double limInferior[] = new double[tokensInferior.countTokens()];
		double limSuperior[] = new double[tokensSuperior.countTokens()];
		String califReserva[] = new String[tokensCalifica.countTokens()];   // Checar para guardar caracteres
		
		int i=0;
		while(tokensInferior.hasMoreTokens()){
			limInferior[i] = Double.parseDouble(tokensInferior.nextToken());
			i++;
		}
		i=0;
		while(tokensSuperior.hasMoreTokens()){
			limSuperior[i] = Double.parseDouble(tokensSuperior.nextToken());
			i++;
		}
		i=0;
		while(tokensCalifica.hasMoreTokens()){
			califReserva[i] = String.valueOf(tokensCalifica.nextToken());
			i++;
		}
		for(int contador=0; contador < limInferior.length; contador++){
			califRango = new CalPorRangoBean();
			califRango.setTipoInstitucion(calPorRangoBean.getTipoInstitucion());
			califRango.setClasificacion(calPorRangoBean.getClasificacion());
			califRango.setTipo(calPorRangoBean.getTipo());
			califRango.setLimInferior(String.valueOf(limInferior[contador]));
			califRango.setLimSuperior(String.valueOf(limSuperior[contador]));
			califRango.setCalificacion(String.valueOf(califReserva[contador])); 	
		
			listaDias.add(califRango);
		}
		return listaDias;
	}

	public List lista(int tipoLista, CalPorRangoBean califRango){
		List califReservaLista = null;
		switch (tipoLista) {
			case Enum_Lis_CalifRango.califRango:
				califReservaLista = calPorRangoDAO.lista(califRango, tipoLista);
			break;
		}
		return califReservaLista;
	}
	
	
	public CalPorRangoDAO getCalPorRangoDAO() {
		return calPorRangoDAO;
	}
	public void setCalPorRangoDAO(CalPorRangoDAO calPorRangoDAO) {
		this.calPorRangoDAO = calPorRangoDAO;
	}
	
}
