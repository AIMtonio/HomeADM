package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import java.util.List;
import credito.bean.CarCambioFondeoBitBean;
import credito.dao.CarCambioFondeoBitDAO;

public class CarCambioFondeoBitServicio extends BaseServicio {
	CarCambioFondeoBitDAO carCambioFondeoBitDAO = null;
	
	/* =====================================================================  */
	/* =====================================================================  */
	private CarCambioFondeoBitServicio(){
		super();
	}
		
	/* =====================================================================  */
	/* =====================================================================  */
	public static interface Enum_Tra_CarCambioFondeo{
		int cargaArchivoFondeo = 1;
		int CambioFuenteFondeo = 2;
		int procesoCamFuentFonMas = 3;
}
	
	public static interface Enum_Lis_CarCambioFondeo{
		int lisCredFondeoErr = 1;
	}
	
	// Consulta de personas
	public static interface Enum_Con_CarCambioFondeo{

	}
	
	/* =====================================================================  */
	/* ========================= METODO TRANSACIONAL =======================  */

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion,CarCambioFondeoBitBean carCambioFondeoBitBean) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case (Enum_Tra_CarCambioFondeo.cargaArchivoFondeo):
				mensaje = carCambioFondeoBitDAO.cargaArchivoFondeo(carCambioFondeoBitBean);
				break;
			case (Enum_Tra_CarCambioFondeo.CambioFuenteFondeo):
				mensaje = carCambioFondeoBitDAO.cambioFuenteFondeo(carCambioFondeoBitBean);
				break;
			case (Enum_Tra_CarCambioFondeo.procesoCamFuentFonMas):
				mensaje = carCambioFondeoBitDAO.cambioFuenteFondeoMasivo(carCambioFondeoBitBean);
				break;
		}
		return mensaje;
	}	

	/* =====================================================================  */
	/* =========================== METODO DE LISTA =========================  */
	
	public List lista(int tipoLista, CarCambioFondeoBitBean carCambioFondeoBitBean){
		List listaResult = null;
		switch (tipoLista) {
			case (Enum_Lis_CarCambioFondeo.lisCredFondeoErr):
				listaResult = carCambioFondeoBitDAO.lisCredFondeoErr(carCambioFondeoBitBean, tipoLista);
				break;	       	
		}
		return listaResult;
	}

	/* =====================================================================  */
	/* ========================= METODO DE CONSULTA ========================  */
	public CarCambioFondeoBitBean consulta(int tipoConsulta, CarCambioFondeoBitBean carCambioFondeoBitBean) {
		CarCambioFondeoBitBean consultaRetornada = null;
		
		switch (tipoConsulta) {

		}		
		return consultaRetornada;		
	}

	
	public CarCambioFondeoBitDAO getCarCambioFondeoBitDAO() {
		return carCambioFondeoBitDAO;
	}

	public void setCarCambioFondeoBitDAO(CarCambioFondeoBitDAO carCambioFondeoBitDAO) {
		this.carCambioFondeoBitDAO = carCambioFondeoBitDAO;
	}
	
}
