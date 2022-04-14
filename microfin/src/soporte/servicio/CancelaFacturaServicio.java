package soporte.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import soporte.bean.CancelaFacturaBean;
import soporte.dao.CancelaFacturaDAO;

public class CancelaFacturaServicio extends BaseServicio{
	CancelaFacturaDAO cancelaFacturaDAO=null;
	
	private CancelaFacturaServicio(){
		super();		
	}
	
	public static interface Enum_Lis_CancelaFactura{
		int listaFolioFiscal= 1;
	}
	public static interface Enum_Lis_Grid_CancelaFactura{
		int listaGridFolioFiscal= 2;
		int listaGridFecha=3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(CancelaFacturaBean cancelaFacturaBean){		
		MensajeTransaccionBean mensaje = null;						
			mensaje = cancelaFacturaDAO.cancelaFactura(cancelaFacturaBean);
		return mensaje;
	}
		
	public List lista(int tipoLista,CancelaFacturaBean cancelaFacturaBean){
		List cancelaFacturaLista = null;
		switch (tipoLista) {
			case Enum_Lis_CancelaFactura.listaFolioFiscal:
				cancelaFacturaLista = cancelaFacturaDAO.listaFolioFiscal(cancelaFacturaBean, tipoLista);
			break;			
			case Enum_Lis_Grid_CancelaFactura.listaGridFolioFiscal:
				cancelaFacturaLista = cancelaFacturaDAO.listaGridPorFolio(cancelaFacturaBean, tipoLista);
			break;
			case Enum_Lis_Grid_CancelaFactura.listaGridFecha:				
				cancelaFacturaLista = cancelaFacturaDAO.listaGridPorFecha(cancelaFacturaBean, tipoLista);
			break;
		}
		return cancelaFacturaLista;
	} 
	
	public CancelaFacturaDAO getCancelaFacturaDAO() {
		return cancelaFacturaDAO;
	}
	public void setCancelaFacturaDAO(CancelaFacturaDAO cancelaFacturaDAO) {
		this.cancelaFacturaDAO = cancelaFacturaDAO;
	}
}
