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

public class CreditosMenor100DAO extends BaseDAO{
	public CreditosMenor100DAO () {
		super ();
	}
	// Consulta para Reporte de Créditos menor a $ 100,000.00 en Excel
	public List reporteCredMenor100mil(UACIRiesgosBean riesgosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call CREDMENORCIENMILREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
	
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMenor100DAO.listaMenorCienMil",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDMENORCIENMILREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCarteraAnterior(resultSet.getString("Var_MontoCarDiaAntExc"));
				riesgos.setSaldoCarteraCredito(resultSet.getString("Var_SaldoCarDiaAnt"));
				riesgos.setResultadoPorcentual(resultSet.getString("Var_Porcentual"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_Porcentaje"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimite"));
	
				riesgos.setSaldoCartera(resultSet.getString("Var_SaldosCreditos"));
				riesgos.setSaldoTotalCartera(resultSet.getString("Var_SalTotCartera"));
				riesgos.setResultadoPorcCredito(resultSet.getString("Var_PorcentSaldo"));
				riesgos.setParametroPorcCredito(resultSet.getString("Var_Porcentaje"));
				riesgos.setDifLimiteEstabCredito(resultSet.getString("Var_DifLimiteSaldo"));
				
				return riesgos;
			}
		});
		return matches;
	}
	
	// Consulta para la pantalla de Créditos menor a $ 100,000.00
	public UACIRiesgosBean consultaCredMenorCienMil(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDMENORCIENMILREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosMenor100DAO.consultaMenorCienMil",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDMENORCIENMILREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCarteraAnterior(resultSet.getString("Var_MontoCarDiaAnt"));
				riesgos.setSaldoCarteraCredito(resultSet.getString("Var_SaldoCarDiaAnt"));
				riesgos.setResultadoPorcentual(resultSet.getString("Var_Porcentual"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_Porcentaje"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimite"));
				
				riesgos.setSaldoCartera(resultSet.getString("Var_SaldosCreditos"));
				riesgos.setSaldoTotalCartera(resultSet.getString("Var_SalTotCartera"));
				riesgos.setResultadoPorcCredito(resultSet.getString("Var_PorcentSaldo"));
				riesgos.setParametroPorcCredito(resultSet.getString("Var_Porcentaje"));
				riesgos.setDifLimiteEstabCredito(resultSet.getString("Var_DifLimiteSaldo"));

				return riesgos;
			}
		});
				
		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}
