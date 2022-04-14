package originacion.dao;

import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import originacion.bean.ReporteConsolidacionBean;

public class ReporteConsolidacionDAO extends BaseDAO {
		
	ParametrosSesionBean parametrosSesionBean;
	
	public ReporteConsolidacionDAO() {
		super();
	}
	
	@SuppressWarnings("rawtypes")
	public List listaConsolidaciones( ReporteConsolidacionBean reporteConsolidacionBean){	
		List ListaResultado=null;
		try{
		String query = "call CONSOLIDACIONESREP(?,?,?,?,?, ?,?,?,?,?, "
				+ 							   "?)";

		Object[] parametros ={
							Utileria.convierteFecha(reporteConsolidacionBean.getFechaInicial()),
							Utileria.convierteFecha(reporteConsolidacionBean.getFechaFinal()),
							Utileria.convierteEntero(reporteConsolidacionBean.getSucursalID()),
							Utileria.convierteEntero(reporteConsolidacionBean.getProductoCredito()),

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSOLIDACIONESREP(  " + Arrays.toString(parametros) + ")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ReporteConsolidacionBean reporteConsolidacionBean= new ReporteConsolidacionBean();
						
						reporteConsolidacionBean.setClienteID(resultSet.getString("ClienteID"));
						reporteConsolidacionBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
						reporteConsolidacionBean.setCreditoOrigenID(resultSet.getString("CreditoOrigenID"));
						reporteConsolidacionBean.setCreditoDestinoID(resultSet.getString("CreditoDestinoID"));
						reporteConsolidacionBean.setProductoDestino(resultSet.getString("ProductoDestino"));
						reporteConsolidacionBean.setFechaConsolidacion(resultSet.getString("FechaMinistrado"));
						reporteConsolidacionBean.setEstatusInicial(resultSet.getString("Estatus"));
						reporteConsolidacionBean.setEstatusCredito(resultSet.getString("EstatusActual"));
						reporteConsolidacionBean.setMontoOriginal(resultSet.getString("MontoOriginal"));
						reporteConsolidacionBean.setPagoSostenido(resultSet.getString("NumPagoSoste"));	
						reporteConsolidacionBean.setSaldoTotalCapital(resultSet.getString("SaldoTotalCapital"));
						reporteConsolidacionBean.setSaldoInteresTotal(resultSet.getString("SaldoInteresTotal"));
						reporteConsolidacionBean.setSaldoMoratorioTotal(resultSet.getString("SaldoMoratorioTotal"));
						reporteConsolidacionBean.setHora(resultSet.getString("Hora"));
				
					return reporteConsolidacionBean ;
				}
			});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Consolidaciones", e);
		}
		return ListaResultado;
	}
}
