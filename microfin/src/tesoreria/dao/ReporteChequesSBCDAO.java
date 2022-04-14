package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
 
import tesoreria.bean.ReporteChequesSBCBean;


import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ReporteChequesSBCDAO extends BaseDAO{
	
	
	public List<ReporteChequesSBCBean> consultaChequesSBCExcel(
			ReporteChequesSBCBean reporteChequesSBCBean, int tipoLista) {
		// TODO Auto-generated method stub
		List listaResultado = null;
		
		try{
		String query = "call RECEPCHEQUESBCREP(?,?,?,?,?  ,?,?,?,?,?   ,?,?,?,?)";
		
		Object[] parametros ={
				Utileria.convierteFecha(reporteChequesSBCBean.getFechaInicial()),
				Utileria.convierteFecha(reporteChequesSBCBean.getFechaFinal()),
				Utileria.convierteEntero(reporteChequesSBCBean.getNoCuentaInstituIni()),
				Utileria.convierteFecha(reporteChequesSBCBean.getSucursalID()),
				Utileria.convierteEntero(reporteChequesSBCBean.getClienteIDIni()),
				Utileria.convierteEntero(reporteChequesSBCBean.getInstitucionIDIni()),				
				reporteChequesSBCBean.getEstatusCheque(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ReporteChequesSBCDAO.consultaChequesSBCExcel",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RECEPCHEQUESBCREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReporteChequesSBCBean reporteChequesSBC= new ReporteChequesSBCBean();
				
				reporteChequesSBC.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
				reporteChequesSBC.setNombreCliente(resultSet.getString("NombreCliente"));
				reporteChequesSBC.setCuentaAhoID(String.valueOf(resultSet.getString("CuentaAhoID")));
				reporteChequesSBC.setBancoEmisor(String.valueOf(resultSet.getInt("BancoEmisor")));
				reporteChequesSBC.setNombreInstitucion(resultSet.getString("NombBanEmisor"));
				reporteChequesSBC.setCuentaEmisor(String.valueOf(resultSet.getLong("CuentaEmisor")));
				reporteChequesSBC.setNumCheque(String.valueOf(resultSet.getInt("NumCheque")));
				reporteChequesSBC.setNombreEmisor(resultSet.getString("NombreEmisor"));
				reporteChequesSBC.setCuentaAplica(String.valueOf(resultSet.getLong("CuentaAplica")));				
				reporteChequesSBC.setMonto(String.valueOf(resultSet.getDouble("Monto")));
				reporteChequesSBC.setEstatus(resultSet.getString("Estatus"));
				reporteChequesSBC.setFechaRecepcion(String.valueOf(resultSet.getDate("FechaRecepcion")));
				reporteChequesSBC.setFechaAplicacion(String.valueOf(resultSet.getDate("FechaAplicacion")));
				reporteChequesSBC.setInstAplica(String.valueOf(resultSet.getLong("NumInstAplica")));
				reporteChequesSBC.setNombInsAplica(resultSet.getString("NombreInsAplica"));
				reporteChequesSBC.setFormaAplica(resultSet.getString("FormaAplica"));
				reporteChequesSBC.setSucursalID(String.valueOf(resultSet.getInt("SucursalID")));
				reporteChequesSBC.setNombreSucursal(resultSet.getString("NombreSucurs"));
				
				
				
				return reporteChequesSBC ;
			}
		});
		listaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de SBC", e);
		}
		return listaResultado;
	}

}
