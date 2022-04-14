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
import herramientas.Utileria;
 
public class CreditosSectorEconomicoDAO extends BaseDAO{
	public CreditosSectorEconomicoDAO () {
		super ();
	}
	// Lista para el Grid de Monto de Cartera por Sector Economico
	public List listaMontoSectorEconomico(int tipoLista,UACIRiesgosBean riesgosBean) {
		String query = "call CREDSECTORECONOMICOREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosSectorEconomicoDAO.listaSector",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDSECTORECONOMICOREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setDescActEconomica(resultSet.getString("Descripcion"));
				riesgos.setMontoCartera(resultSet.getString("MontoCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("Resultado"));
				riesgos.setParametroPorcentaje(resultSet.getString("Porcentaje"));
				riesgos.setDifLimiteSecEcon(resultSet.getString("Diferencia")); 
				
				return riesgos;
			}
		});
		return matches;
	}
	
	// Lista para el Grid de Saldo de Cartera por Sector Economico
	public List listaSaldoSectorEconomico(int tipoLista,UACIRiesgosBean riesgosBean) {
		String query = "call CREDSECTORECONOMICOREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosSectorEconomicoDAO.listaSector",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDSECTORECONOMICOREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setDescActEconomica(resultSet.getString("Descripcion"));
				riesgos.setSaldoCartera(resultSet.getString("SaldoCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("Resultado"));
				riesgos.setParametroPorcentaje(resultSet.getString("Porcentaje"));
				riesgos.setDifLimiteSecEcon(resultSet.getString("Diferencia")); 

				return riesgos;
			}
		});
		return matches;
	}
	
	// Reporte de Créditos por Sector Económico
	public List reporteSectorEconomico(UACIRiesgosBean riesgosBean,int tipoLista) {
		String query = "call CREDSECTORECONOMICOREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosSectorEconomicoDAO.listaSectorEco",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDSECTORECONOMICOREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setDescActEconomica(resultSet.getString("Descripcion"));
				riesgos.setMontoActEconomica(resultSet.getString("MontoCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("ResultadoMonto"));
				riesgos.setParametroPorcentaje(resultSet.getString("PorcentajeMonto"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("DiferenciaMonto"));
				
				riesgos.setSaldoCartera(resultSet.getString("SaldoCredito"));
				riesgos.setResPorcentualSecEcon(resultSet.getString("ResultadoSaldo"));
				riesgos.setParamPorcentajeSecEcon(resultSet.getString("PorcentajeSaldo"));
				riesgos.setDifLimiteSecEcon(resultSet.getString("DiferenciaSaldo"));


				return riesgos;
			}
		});
		return matches;
	}
	

	// Consulta para la pantalla de Créditos por Sector Económico
	public UACIRiesgosBean consultaCarteraCredito(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDSECTORECONOMICOREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoConsulta,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosSectorEconomicoDAO.consultaSectorEco",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDSECTORECONOMICOREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setTotalCarteraCredito(resultSet.getString("Var_SalTotCartera"));
				
				return riesgos;
			}
		});
				
		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
	// Consulta para la pantalla de Créditos por Sector Económico
		public UACIRiesgosBean consultaMontoCarteraCredito(UACIRiesgosBean riesgosBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call CREDSECTORECONOMICOREP(?,?,    ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
					tipoConsulta,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosSectorEconomicoDAO.consultaSectorEco",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDSECTORECONOMICOREP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					UACIRiesgosBean riesgos = new UACIRiesgosBean();
					riesgos.setMontoActEconomica(resultSet.getString("Var_MontoCreditoTotal"));
					
					return riesgos;
				}
			});
					
			return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
		}
}
