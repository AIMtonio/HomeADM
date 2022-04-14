package credito.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.PorReservaPeriodoBean;
import credito.dao.PorReservaPeriodoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class PorReservaPeriodoServicio extends BaseServicio {
	PorReservaPeriodoDAO porReservaPeriodoDAO = null;
	
	public static interface Enum_Tra_Reserva {
		int alta = 1;
	}
	public static interface Enum_Lis_Reserva {
		int porcSofipoViv = 1;
		int reservaDias = 2;
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PorReservaPeriodoBean reservaPeriodo, 
													String limInferiores, String limSuperiores, String cartSReest, String cartReest){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_Reserva.alta:
				mensaje = altaReservaDias(reservaPeriodo, limInferiores, limSuperiores, cartSReest, cartReest);
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaReservaDias(PorReservaPeriodoBean reservaPeriodo, String limInferiores, String limSuperiores, String cartSReest, String cartReest){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaReservaDias = (ArrayList) creaListaDiasInversion(reservaPeriodo, limInferiores, limSuperiores, cartSReest, cartReest);
		mensaje = porReservaPeriodoDAO.grabaListaDiasAtraso(reservaPeriodo, listaReservaDias );
		return mensaje;
	}
	
	private List creaListaDiasInversion(PorReservaPeriodoBean reservaPeriodo, String limInferiores,	 String limSuperiores, String cartSReest, String cartReest){
		StringTokenizer tokensInferior = new StringTokenizer(limInferiores, ",");
		StringTokenizer tokensSuperior = new StringTokenizer(limSuperiores, ",");
		StringTokenizer tokenscartSin = new StringTokenizer(cartSReest, ",");
		StringTokenizer tokenscartReest = new StringTokenizer(cartReest, ",");
		ArrayList listaDias = new ArrayList();
		PorReservaPeriodoBean reservaPeriodoBean;

		int limInferior[] = new int[tokensInferior.countTokens()];
		int limSuperior[] = new int[tokensSuperior.countTokens()];
		double cartSinReest[] = new double[tokenscartSin.countTokens()];
		double cartConReest[] = new double[tokenscartReest.countTokens()];

		int i=0;
		while(tokensInferior.hasMoreTokens()){
			limInferior[i] = Integer.parseInt(tokensInferior.nextToken());
			i++;
		}
		i=0;
		while(tokensSuperior.hasMoreTokens()){
			limSuperior[i] = Integer.parseInt(tokensSuperior.nextToken());
			i++;
		}
		i=0;
		while(tokenscartSin.hasMoreTokens()){
			String str=tokenscartSin.nextToken();
			cartSinReest[i] = Double.valueOf(str).doubleValue();
            i++;

		}
		i=0;
		while(tokenscartReest.hasMoreTokens()){
			cartConReest[i] = Double.valueOf(tokenscartReest.nextToken()).doubleValue();
			i++;
		}
		for(int contador=0; contador < limInferior.length; contador++){
			reservaPeriodoBean = new PorReservaPeriodoBean();
			reservaPeriodoBean.setTipoInstitucion(reservaPeriodo.getTipoInstitucion());
			reservaPeriodoBean.setClasificacion(reservaPeriodo.getClasificacion());
			reservaPeriodoBean.setTipoRango(reservaPeriodo.getTipoRango());
			reservaPeriodoBean.setLimInferior(String.valueOf(limInferior[contador]));
			reservaPeriodoBean.setLimSuperior(String.valueOf(limSuperior[contador]));
			reservaPeriodoBean.setPorResCarSReest(String.valueOf(cartSinReest[contador]));
			reservaPeriodoBean.setPorResCarReest(String.valueOf(cartConReest[contador]));
			listaDias.add(reservaPeriodoBean);
		}
		return listaDias;
	}
	
	public List lista(int tipoLista, PorReservaPeriodoBean reservaPeriodo){
		List diasInverLista = null;
		switch (tipoLista) {
			case Enum_Lis_Reserva.porcSofipoViv:
				diasInverLista = porReservaPeriodoDAO.porcSofipoViv(reservaPeriodo, tipoLista);
				break;
			case Enum_Lis_Reserva.reservaDias:
				diasInverLista = porReservaPeriodoDAO.reservaDias(reservaPeriodo, tipoLista);
				break;
		}
		return diasInverLista;
	}


	public PorReservaPeriodoDAO getPorReservaPeriodoDAO() {
		return porReservaPeriodoDAO;
	}

	public void setPorReservaPeriodoDAO(PorReservaPeriodoDAO porReservaPeriodoDAO) {
		this.porReservaPeriodoDAO = porReservaPeriodoDAO;
	}

}
