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

public class CreditosMayorInsoluto3PorcDAO extends BaseDAO{
	public CreditosMayorInsoluto3PorcDAO (){
		super();
	}
	
	// Consulta de Mayor Saldo Insoluto 3.5 %. (Grid)
	public List listaGridMayorSaldo3Porc(int tipoLista,UACIRiesgosBean riesgosBean) {
		String query = "call CREDITOSMAYOR3PORCREP(?,?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsoluto3PorcDAO.mayorSaldo3Porc",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYOR3PORCREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setClienteID(resultSet.getString("ClienteID"));
				bean.setCreditoID(resultSet.getString("CreditoID"));
				bean.setSaldoInsoluto(resultSet.getString("SaldoInsoluto"));
				bean.setSucursalID(resultSet.getString("SucursalID"));
				bean.setDifMontoCapNeto(resultSet.getString("DiferenciaMonto"));
				return bean;
			}
		});
		return matches;
	}
	
	// Lista para el reporte en Excel Mayor Saldo Insoluto 3.5 %
	public List reporteMayorSaldoInsoluto3Porc(UACIRiesgosBean riesgosBean,int tipoLista) {
		String query = "call CREDITOSMAYOR3PORCREP(?,?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsoluto3PorcDAO.mayorSaldo3Porc",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYOR3PORCREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setClienteID(resultSet.getString("ClienteID"));
				bean.setCreditoID(resultSet.getString("CreditoID"));
				bean.setSaldoInsoluto(resultSet.getString("SaldoInsoluto"));
				bean.setSucursalID(resultSet.getString("SucursalID"));
				bean.setDifMontoCapNeto(resultSet.getString("DiferenciaMontoExc"));
				bean.setCapitalNetoMensual(resultSet.getString("CapitalNetoMes"));
				bean.setResultadoPorcentual(resultSet.getString("ResultadoCapNeto"));
				bean.setParametroPorcentaje(resultSet.getString("Porcentaje"));
				return bean;
			}
		});
		return matches;
	}
	
	// Consuta parametros de riesgos 3.5 %
	public UACIRiesgosBean consultaParametro(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		String query = "call CREDITOSMAYOR3PORCREP(?,?,?,    ?,?,?,?,?,?,?);";

		Object[] parametros = { 
				riesgosBean.getAnio(),
				riesgosBean.getMes(),
				tipoConsulta,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMayorInsoluto3PorcDAO.consultaParam",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSMAYOR3PORCREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean bean = new UACIRiesgosBean();
				bean.setCapitalNetoMensual(resultSet.getString("Var_CapitalNeto"));
				bean.setResultadoPorcentual(resultSet.getString("Var_ResCapNet3Porc"));
				bean.setParametroPorcentaje(resultSet.getString("Var_PorCredPorc"));
				return bean;
			}
		});

		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}
