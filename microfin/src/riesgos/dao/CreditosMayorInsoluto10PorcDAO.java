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

public class CreditosMayorInsoluto10PorcDAO extends BaseDAO{
	public CreditosMayorInsoluto10PorcDAO (){
		super ();
	}
	
	// Consulta de Mayor Saldo Insoluto 10 %. (Grid)
	public List listaGridMayorSaldo10Porc(int tipoLista,UACIRiesgosBean riesgosBean) {
		String query = "call CREDITOSMAYOR10PORCREP(?,?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsoluto10PorcDAO.mayor10Porc",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYOR10PORCREP(" + Arrays.toString(parametros) +")");
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
	
	// Lista para el reporte en Excel Mayor Saldo Insoluto 10 %
	public List reporteMayorSaldoInsoluto10Porc(UACIRiesgosBean riesgosBean,int tipoLista) {
		String query = "call CREDITOSMAYOR10PORCREP(?,?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoLista,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsoluto10PorcDAO.mayor10Porc",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYOR10PORCREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setClienteID(resultSet.getString("ClienteID"));
				bean.setCreditoID(resultSet.getString("CreditoID"));
				bean.setSaldoInsoluto(resultSet.getString("SaldoInsoluto"));
				bean.setSucursalID(resultSet.getString("SucursalID"));
				bean.setTotalCarteraCredito(resultSet.getString("Var_SaldoTotCartera"));
				bean.setParametroPorcentaje(resultSet.getString("Var_PorCred10Porc"));
				return bean;
			}
		});
		return matches;
	}
	
	// Consuta parametros de riesgos 10 %
	public UACIRiesgosBean consultaParametro(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		String query = "call CREDITOSMAYOR10PORCREP(?,?,?,    ?,?,?,?,?,?,?);";

		Object[] parametros = { 
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoConsulta,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsoluto10PorcDAO.consultaParam",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYOR10PORCREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setTotalSaldoInsoluto(resultSet.getString("Var_TotSaldoInsoluto"));
				bean.setTotalCarteraCredito(resultSet.getString("Var_SaldoTotCartera"));
				bean.setResultadoPorcentual(resultSet.getString("Var_Resultado"));
				bean.setParametroPorcentaje(resultSet.getString("Var_PorCred10Porc"));
				bean.setDifLimiteEstablecido(resultSet.getString("Var_DifLimite"));
				return bean;
			}
		});

		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}

