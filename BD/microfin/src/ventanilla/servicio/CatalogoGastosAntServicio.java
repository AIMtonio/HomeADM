package ventanilla.servicio;


import java.io.ByteArrayOutputStream;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;

import contabilidad.servicio.TipoInstrumentosServicio.Enum_Con_tipoInstrumentos;
import ventanilla.bean.CajasVentanillaBean;
import ventanilla.bean.CatalogoGastosAntBean;
import ventanilla.dao.CatalogoGastosAntDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
 
public class CatalogoGastosAntServicio extends BaseServicio {
	CatalogoGastosAntDAO catalogoGastosAntDAO = null;
	
	public static interface Enum_Tra_CatalogoServ {
		int alta = 1;
		int modificacion = 2;
	}
	public static interface Enum_Con_CatalogoServ {
		int principal = 1;
		int foranea	  = 2;
		int salidaEfect =3;
	}
	public static interface Enum_Lis_CatalogoServ {
		int principal	= 1;
		int lis_Combo	= 3;
		int lis_ComboEntra=4;
		int lis_Naturaleza=5;
	}
	
	public CatalogoGastosAntServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	CatalogoGastosAntBean catalogoGastosAntBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_CatalogoServ.alta:		
				mensaje = catalogoGastosAntDAO.alta(catalogoGastosAntBean);								
				break;			
			case Enum_Tra_CatalogoServ.modificacion:		
				mensaje = catalogoGastosAntDAO.modifica(catalogoGastosAntBean);								
				break;		
		}
		return mensaje;
	}
	
	public CatalogoGastosAntBean consulta(int tipoConsulta, CatalogoGastosAntBean catalogoGastosAntBean){
		CatalogoGastosAntBean catalogoGastosAnt = null;
		switch (tipoConsulta) {
			case Enum_Con_CatalogoServ.principal:	
				catalogoGastosAnt = catalogoGastosAntDAO.consultaPrincipal(catalogoGastosAntBean,tipoConsulta);
			break;		
			case Enum_Con_CatalogoServ.salidaEfect:	
				catalogoGastosAnt = catalogoGastosAntDAO.consultaPrincipal(catalogoGastosAntBean,tipoConsulta);
			break;
		}
		return catalogoGastosAnt;
	}


	public List lista(int tipoLista, CatalogoGastosAntBean catalogoGastosAntBean){		
		List listaCatGasto = null;
		switch (tipoLista) {
		case Enum_Lis_CatalogoServ.principal:		
			listaCatGasto =catalogoGastosAntDAO.listaPrincipal(catalogoGastosAntBean,tipoLista);				
			break;		
		case Enum_Lis_CatalogoServ.lis_Naturaleza:		
			listaCatGasto =catalogoGastosAntDAO.listaNaturaleza(catalogoGastosAntBean,tipoLista);				
			break;	
		}		
		return listaCatGasto;
	}			
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaComboGastos = null;
		switch(tipoLista){
			case Enum_Lis_CatalogoServ.lis_Combo:
				listaComboGastos = catalogoGastosAntDAO.listaComboGastosAnt(tipoLista);
			break;
			case Enum_Lis_CatalogoServ.lis_ComboEntra:
				listaComboGastos = catalogoGastosAntDAO.listaComboGastosAnt(tipoLista);
			break;
						
		}
		return listaComboGastos.toArray();		
	}
	
	
	
	//Se cre el Reporte de Movimientos de Gastos y Anticipos 
	public ByteArrayOutputStream creaRepGastosAnticiposPDF(CatalogoGastosAntBean catalogoGastosAntBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicial",catalogoGastosAntBean.getFechaIni());
		parametrosReporte.agregaParametro("Par_FechaFinal",catalogoGastosAntBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_Operacion",catalogoGastosAntBean.getTipoAntGastoID());
		parametrosReporte.agregaParametro("Par_Naturaleza",catalogoGastosAntBean.getNaturaleza());
		parametrosReporte.agregaParametro("Par_Sucursal",catalogoGastosAntBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_CajaID",catalogoGastosAntBean.getCajaID());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",catalogoGastosAntBean.getNombreInstitucion());
		
		parametrosReporte.agregaParametro("Par_NombreSucursal",catalogoGastosAntBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_NombreCaja",catalogoGastosAntBean.getDescripcionCaja());
		parametrosReporte.agregaParametro("Par_ClaUsuario",catalogoGastosAntBean.getUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",catalogoGastosAntBean.getFecha());
		parametrosReporte.agregaParametro("Par_DescTipoOperacion",catalogoGastosAntBean.getDescripcion());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	
	
	//--------- getter y setter 	-------------


	public CatalogoGastosAntDAO getCatalogoGastosAntDAO() {
		return catalogoGastosAntDAO;
	}

	public void setCatalogoGastosAntDAO(CatalogoGastosAntDAO catalogoGastosAntDAO) {
		this.catalogoGastosAntDAO = catalogoGastosAntDAO;
	}
	
	

}
