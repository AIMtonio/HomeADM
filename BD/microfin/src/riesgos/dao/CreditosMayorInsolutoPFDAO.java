package riesgos.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import riesgos.bean.UACIRiesgosBean;

public class CreditosMayorInsolutoPFDAO extends BaseDAO{
	public CreditosMayorInsolutoPFDAO (){
		super ();
	}
	
	// Consulta de Mayor Saldo Insoluto P.F. (Grid)
	public List listaGridMayorSaldoPF(int tipoLista,UACIRiesgosBean riesgosBean) {
		String query = "call CREDITOSMAYORPFREP(?,?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsolutoPFDAO.listaGridMayorSaldoPF",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYORPFREP(" + Arrays.toString(parametros) +")");
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
	
	// Lista para el reporte en Excel Mayor Saldo Insoluto P.F.
	public List reporteMayorSaldoInsolutoPF(UACIRiesgosBean riesgosBean,int tipoLista) {
		String query = "call CREDITOSMAYORPFREP(?,?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsolutoPFDAO.listaGridMayorSaldoPF",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYORPFREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setClienteID(resultSet.getString("ClienteID"));
				bean.setCreditoID(resultSet.getString("CreditoID"));
				bean.setSaldoInsoluto(resultSet.getString("SaldoInsoluto"));
				bean.setSucursalID(resultSet.getString("SucursalID"));
				bean.setCapitalNetoMensual(resultSet.getString("Var_CapitalNeto"));
				bean.setParametroPorcentaje(resultSet.getString("Var_PorcentajeCredPF"));

				return bean;
			}
		});
		return matches;
	}
	
	// Consuta parametros de riesgos P.F.
	public UACIRiesgosBean consultaParametro(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		String query = "call CREDITOSMAYORPFREP(?,?,?,    ?,?,?,?,?,?,?);";

		Object[] parametros = { 
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoConsulta,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsolutoPFDAO.consultaParametro",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYORPFREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setTotalSaldoInsolutoPF(resultSet.getString("Var_TotSaldoInsoluto"));
				bean.setCapitalNetoMensual(resultSet.getString("Var_CapitalNeto"));
				bean.setResultadoPorcentual(resultSet.getString("Var_PorcentualCredPF"));
				bean.setParametroPorcentaje(resultSet.getString("Var_PorcentajeCredPF"));
				return bean;
			}
		});

		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}
