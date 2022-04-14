package cuentas.dao;
import org.springframework.jdbc.core.JdbcTemplate;

 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import cuentas.bean.AportacionSocioBean;
import cuentas.bean.RepAportaSocioMovBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class AportacionSocioDAO extends BaseDAO{
	public AportacionSocioDAO() {
		super();
	}
	
	
	public AportacionSocioBean consultaPrincipal(AportacionSocioBean aportacionSocioBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call APORTACIONSOCIOCON(?,?,?,?,?,  ?,?,?,?);";
		Object[] parametros = {	
								Utileria.convierteEntero(aportacionSocioBean.getClienteID()),
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"AportacionSocioDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONSOCIOCON(" + Arrays.toString(parametros) + ")");
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportacionSocioBean aportacionSocio = new AportacionSocioBean();			
					
				aportacionSocio.setClienteID(resultSet.getString("ClienteID"));
				aportacionSocio.setSaldo(resultSet.getString("Saldo"));		
				aportacionSocio.setSucursalID(resultSet.getString("SucursalID"));	
				aportacionSocio.setFechaRegistro(resultSet.getString("FechaRegistro"));
				aportacionSocio.setUsuarioID(resultSet.getString("FechaRegistro"));
				aportacionSocio.setCreditoID(resultSet.getString("CreditoID"));
				aportacionSocio.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				aportacionSocio.setInversionID(resultSet.getString("InversionID"));
				aportacionSocio.setMontoAplicacion(resultSet.getString("MontoAportacion"));
				aportacionSocio.setFechaImp(resultSet.getString("FechaCertificado"));
				return aportacionSocio;
			}
		});
		return matches.size() > 0 ? (AportacionSocioBean) matches.get(0) : null;
				
	}
	
	
	
	public List listaMovimientos(RepAportaSocioMovBean repAportaSocioMovBean, int tipoLista){
		String query = "call APORTASOCIOMOVLIS(?,?,?,?,?,  ?,?,?,?);";
		Object[] parametros = {	
				repAportaSocioMovBean.getClienteID(),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"AportacionSocioDAO.listaMovimientos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTASOCIOMOVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepAportaSocioMovBean repAportaSocioMov = new RepAportaSocioMovBean();
				
				repAportaSocioMov.setFecha(resultSet.getString("Fecha"));
				repAportaSocioMov.setNatMovimiento(resultSet.getString("NatMovimiento"));
				repAportaSocioMov.setDescripcionMov(resultSet.getString("DescripcionMov"));
				repAportaSocioMov.setCantidadMov(resultSet.getString("Cantidad"));
				repAportaSocioMov.setSaldo(resultSet.getString("Saldo"));
				return repAportaSocioMov;
			}
		});
		return matches;
	}
	
}
