package activos.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import activos.bean.AplicacionDepreciacionBean;
import activos.dao.AplicacionDepreciacionDAO;
import activos.servicio.TiposActivosServicio.Enum_Lis_ClasifTiposActivos;

public class AplicacionDepreciacionServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------- //
	AplicacionDepreciacionDAO aplicacionDepreciacionDAO = null;
	
	public AplicacionDepreciacionServicio(){
		super();
	}
	
	// ---------- Tipos Transaccion Depreciacion  ---------------- //
	public static interface Enum_Tra_Depreciacion{
		int aplicaDepreciacion	= 1;

	}

	// --- Reporte de Depreciacion y Amortizacion de Activos ---- //
	public static interface Enum_Rep_DepActivos{
		int excel = 1;		
	}
			
	public static interface Enum_Lis_DepActivos{
		int listaAnios = 1;	
		int listaAniosMes = 2;		
	}
	
	/* Transacciones Depreciacion y Amortizacion de Activos */ 
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AplicacionDepreciacionBean aplicacionDepreciacionBean){
		
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case(Enum_Tra_Depreciacion.aplicaDepreciacion):
				mensaje = aplicacionDepreciacionDAO.aplicacionDepreciacionAmortizacion(aplicacionDepreciacionBean, tipoTransaccion);
			break;
		}
		return mensaje;
	}

	// Reporte Previo Aplicacion de Depreciacion y Amortizacion de Activos en Excel
	public List listaDepreciaActivos(int tipoLista,AplicacionDepreciacionBean aplicacionDepreciacionBean, HttpServletResponse response){		
		List listaActivos = null;
		switch(tipoLista){
		case Enum_Rep_DepActivos.excel:
			listaActivos = aplicacionDepreciacionDAO.reporteDepreciaActivos(tipoLista,aplicacionDepreciacionBean);
			break;
		}
		return listaActivos;
	}

	// Descripcion del Mes
	public String descripcionMes(String meses){
		String mes = "";
		int mese = Integer.parseInt(meses);
        switch (mese) {
            case 1:  mes ="ENERO" ; break;
            case 2:  mes ="FEBRERO"; break;
            case 3:  mes ="MARZO"; break;
            case 4:  mes ="ABRIL"; break;
            case 5:  mes ="MAYO"; break;
            case 6:  mes ="JUNIO"; break;
            case 7:  mes ="JULIO"; break;
            case 8:  mes ="AGOSTO"; break;
            case 9:  mes ="SEPTIEMBRE"; break;
            case 10: mes ="OCTUBRE"; break;
            case 11: mes ="NOVIEMBRE"; break;
            case 12: mes ="DICIEMBRE"; break;
        }
        return mes;
	}
	
	// listas para comboBox anios
	public  Object[] listaCombo(int tipoLista, AplicacionDepreciacionBean apliDepreBean) {	
		List listaBean = null;
			
		switch(tipoLista){
			case Enum_Lis_DepActivos.listaAnios: 
				listaBean =  aplicacionDepreciacionDAO.listaAnios(tipoLista,apliDepreBean);
				break;
			case Enum_Lis_DepActivos.listaAniosMes: 
				listaBean =  aplicacionDepreciacionDAO.listaMesesPorAnio(tipoLista,apliDepreBean);
				break;
			
		}
		return listaBean.toArray();		
	}

	/* ============== GETTER & SETTER ===================== */
	public AplicacionDepreciacionDAO getAplicacionDepreciacionDAO() {
		return aplicacionDepreciacionDAO;
	}

	public void setAplicacionDepreciacionDAO(AplicacionDepreciacionDAO aplicacionDepreciacionDAO) {
		this.aplicacionDepreciacionDAO = aplicacionDepreciacionDAO;
	}

}
