package riesgos.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import riesgos.bean.UACIRiesgosBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
 
public class CreditosMayorInsolutoPMDAO extends BaseDAO{
	public CreditosMayorInsolutoPMDAO (){
		super();
	}
	
	// Consulta de Mayor Saldo Insoluto P.M. (Grid)
	public List listaGridMayorSaldoPM(int tipoLista,UACIRiesgosBean riesgosBean) {
		String query = "call CREDITOSMAYORPMREP(?,?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsolutoPMDAO.listaGridMayorSaldoPM",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYORPMREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setClienteID(resultSet.getString("ClienteID"));
				bean.setCreditoID(resultSet.getString("CreditoID"));
				bean.setSaldoInsoluto(resultSet.getString("SaldoInsoluto"));
				bean.setSucursalID(resultSet.getString("SucursalID"));
				return bean;
			}
		});
		return matches;
	}
	
	// Lista para el reporte en Excel Mayor Saldo Insoluto P.M.
	public List reporteMayorSaldoInsolutoPM(UACIRiesgosBean riesgosBean,int tipoLista) {
		String query = "call CREDITOSMAYORPMREP(?,?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsolutoPMDAO.listaGridMayorSaldoPM",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYORPMREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setClienteID(resultSet.getString("ClienteID"));
				bean.setCreditoID(resultSet.getString("CreditoID"));
				bean.setSaldoInsoluto(resultSet.getString("SaldoInsoluto"));
				bean.setSucursalID(resultSet.getString("SucursalID"));
				bean.setCapitalNetoMensual(resultSet.getString("Var_CapitalNeto"));
				bean.setParametroPorcentaje(resultSet.getString("Var_PorcentajeCredPM"));
				return bean;
			}
		});
		return matches;
	}
	
	// Consuta parametros de riesgos P.M.
	public UACIRiesgosBean consultaParametro(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		String query = "call CREDITOSMAYORPMREP(?,?,?,    ?,?,?,?,?,?,?);";

		Object[] parametros = { 
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoConsulta,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsolutoPMDAO.consultaParametro",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYORPMREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setTotalSaldoInsolutoPM(resultSet.getString("Var_TotSaldoInsoluto"));
				bean.setCapitalNetoMensual(resultSet.getString("Var_CapitalNeto"));
				bean.setResultadoPorcentual(resultSet.getString("Var_PorcentualCredPM"));
				bean.setParametroPorcentaje(resultSet.getString("Var_PorcentajeCredPM"));
				return bean;
			}
		});

		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}
