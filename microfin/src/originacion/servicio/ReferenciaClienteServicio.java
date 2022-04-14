package originacion.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

import org.hibernate.loader.custom.Return;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import originacion.dao.ReferenciaClienteDAO;
import originacion.bean.ReferenciaClienteBean;
import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.DistCCInvBancariaBean;
import tesoreria.bean.InvBancariaBean;
import tesoreria.servicio.InvBancariaServicio.Enum_Transaccion;

public class ReferenciaClienteServicio extends BaseServicio{
	
	ReferenciaClienteDAO referenciaClienteDAO = null;
	
	private ReferenciaClienteServicio(){
		super();
	}

	public static interface Enum_Tra_ReferenciaCliente {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_ReferenciaCliente{
		int consulta = 1;
	}

	public static interface Enum_Lis_ReferenciaCliente{
		int lista = 1;
		int lista_pld = 2;
	}
	
	public static interface Enum_Tip_Reporte {
		int excel = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ReferenciaClienteBean referenciaCliente){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_ReferenciaCliente.alta:
			mensaje = referenciaClienteDAO.alta(referenciaCliente);
			break;
		case Enum_Tra_ReferenciaCliente.baja:
			mensaje = referenciaClienteDAO.baja(referenciaCliente);
			break;
		}
		return mensaje;
	}

	/**
	 * Consulta de la lista de referencias utilizado en el Grid del detalle
	 * @param tipoLista
	 * @param referenciaCliente
	 * @return
	 */
	public List<ReferenciaClienteBean> lista(int tipoLista, ReferenciaClienteBean referenciaCliente){
		List<ReferenciaClienteBean> referenciaClienteLista = null;
		switch (tipoLista) {
		case Enum_Lis_ReferenciaCliente.lista:
			referenciaClienteLista = referenciaClienteDAO.listaReferenciaCliente(referenciaCliente, tipoLista);
			break;
		case Enum_Lis_ReferenciaCliente.lista_pld:
			referenciaClienteLista = referenciaClienteDAO.listaPLDCliente(referenciaCliente, tipoLista);
			break;
		}
		return referenciaClienteLista;
	}
	
	public List<ReferenciaClienteBean> listaReporte(int tipoLista,ReferenciaClienteBean referenciaClienteBean) {
		List<ReferenciaClienteBean> listaRep = null;
		switch (tipoLista) {
		case Enum_Tip_Reporte.excel:
			listaRep = referenciaClienteDAO.listaReporte(referenciaClienteBean);
			break;
		}
		return listaRep;
	}

	public ByteArrayOutputStream reporteReferenciasCtePDF(ReferenciaClienteBean referenciaClienteBean, String nombreReporte) throws Exception {
		// TODO Auto-generated method stub
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		try {
			parametrosReporte.agregaParametro("Par_NombreInstitucion", referenciaClienteBean.getNombreInstitucion().toUpperCase());
			parametrosReporte.agregaParametro("Par_FechaInicio", referenciaClienteBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin", referenciaClienteBean.getFechaFin());
			parametrosReporte.agregaParametro("Par_ProductoCredito", referenciaClienteBean.getProductoCreditoID());
			parametrosReporte.agregaParametro("Par_FechaSistema", referenciaClienteBean.getFechaSistema());
			parametrosReporte.agregaParametro("Par_Usuario", referenciaClienteBean.getNombreUsuario().toUpperCase());
			parametrosReporte.agregaParametro("Par_Interesado", referenciaClienteBean.getInteresado());
			parametrosReporte.agregaParametro("Par_NombreProducto", referenciaClienteBean.getNombreProducto());
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el Reporte de Cheques Asignados", e);
		}
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte,
				parametrosAuditoriaBean.getRutaReportes(),
				parametrosAuditoriaBean.getRutaImgReportes());
	}

	public MensajeTransaccionBean grabaDetalle(int tipoTransaccion, ReferenciaClienteBean referenciaClienteBean, String detalles) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList<ReferenciaClienteBean> listaPolizaDetalle = (ArrayList<ReferenciaClienteBean>) creaListaDetalle(detalles);
		switch (tipoTransaccion) {
		case Enum_Transaccion.alta:
			mensaje = referenciaClienteDAO.altaDetalles(referenciaClienteBean, listaPolizaDetalle);
			break;
	}
		return mensaje;
	}


	private List<ReferenciaClienteBean> creaListaDetalle(String detalleString) {
		StringTokenizer tokensBean = new StringTokenizer(detalleString, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList<ReferenciaClienteBean> listaDetalle = new ArrayList<ReferenciaClienteBean>();
		ReferenciaClienteBean detalle;
		
		while (tokensBean.hasMoreTokens()) {
			detalle = new ReferenciaClienteBean();
			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			detalle.setPrimerNombre(tokensCampos[0].equals("N/A")? "":tokensCampos[0]);
			detalle.setSegundoNombre(tokensCampos[1].equals("N/A")? "":tokensCampos[1]);
			detalle.setTercerNombre(tokensCampos[2].equals("N/A")? "":tokensCampos[2]);
			detalle.setApellidoPaterno(tokensCampos[3].equals("N/A")? "":tokensCampos[3]);
			detalle.setApellidoMaterno(tokensCampos[4].equals("N/A")? "":tokensCampos[4]);
			detalle.setTelefono(tokensCampos[5].equals("N/A")? "":tokensCampos[5]);
			detalle.setExtTelefonoPart(tokensCampos[6].equals("N/A")? "":tokensCampos[6]);
			detalle.setValidado(tokensCampos[7].equals("N/A")? "":tokensCampos[7]);
			detalle.setInteresado(tokensCampos[8].equals("N/A")? "":tokensCampos[8]);
			detalle.setTipoRelacionID(tokensCampos[9].equals("N/A")? "0":tokensCampos[9]);
			detalle.setEstadoID(tokensCampos[10].equals("N/A")? "0":tokensCampos[10]);
			detalle.setMunicipioID(tokensCampos[11].equals("N/A")? "0":tokensCampos[11]);
			detalle.setLocalidadID(tokensCampos[12].equals("N/A")? "0":tokensCampos[12]);
			detalle.setColoniaID(tokensCampos[13].equals("N/A")? "0":tokensCampos[13]);
			detalle.setCalle(tokensCampos[14].equals("N/A")? "":tokensCampos[14]);
			detalle.setNumeroCasa(tokensCampos[15].equals("N/A")? "":tokensCampos[15]);
			detalle.setNumInterior(tokensCampos[16].equals("N/A")? "":tokensCampos[16]);
			detalle.setPiso(tokensCampos[17].equals("N/A")? "":tokensCampos[17]);
			detalle.setCp(tokensCampos[18].equals("N/A")? "":tokensCampos[18]);
			
			listaDetalle.add(detalle);
		}
		return listaDetalle;
	}
	
	public ReferenciaClienteDAO getReferenciaClienteDAO() {
		return referenciaClienteDAO;
	}

	public void setReferenciaClienteDAO(ReferenciaClienteDAO referenciaClienteDAO) {
		this.referenciaClienteDAO = referenciaClienteDAO;
	}

}
