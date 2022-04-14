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
 
public class CreditosPagosUnicosDAO extends BaseDAO{
	public CreditosPagosUnicosDAO() {
		super();
	}
	// Consulta para Reporte de Créditos Pagos Únicos en Excel
	public List reportePagoUnico(UACIRiesgosBean riesgosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call CREDITOSPAGOSREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosPagosUnicosDAO.listaPagosUnico",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSPAGOSREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCarteraAnterior(resultSet.getString("Var_MontoPagoUnicoExc"));
				riesgos.setSaldoCarteraCredito(resultSet.getString("Var_SaldoCarDiaAnt"));
				riesgos.setResultadoPorcentual(resultSet.getString("Var_PorcentPagUni"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_PorPagoUnico"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimPagUni"));
				
				riesgos.setSaldoCartera(resultSet.getString("Var_SaldosCreditos"));
				riesgos.setSaldoTotalCartera(resultSet.getString("Var_SalTotCartera"));
				riesgos.setResultadoPorcCredito(resultSet.getString("Var_PorcentPagUniSal"));
				riesgos.setParametroPorcCredito(resultSet.getString("Var_PorPagoUnico"));
				riesgos.setDifLimiteEstabCredito(resultSet.getString("Var_DifLimPagUniSal"));

				return riesgos;
			}
		});
		return matches;
	}
	
	// Consulta para la pantalla de Créditos Pagos Únicos
	public UACIRiesgosBean consultaPagoUnico(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSPAGOSREP(?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosPagosUnicosDAO.consultaPagoUnico",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSPAGOSREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCarteraAnterior(resultSet.getString("Var_MontoPagoUnico"));
				riesgos.setSaldoCarteraCredito(resultSet.getString("Var_SaldoCarDiaAnt"));
				riesgos.setResultadoPorcentual(resultSet.getString("Var_PorcentPagUni"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_PorPagoUnico"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimPagUni"));
				
				riesgos.setSaldoCartera(resultSet.getString("Var_SaldosCreditos"));
				riesgos.setSaldoTotalCartera(resultSet.getString("Var_SalTotCartera"));
				riesgos.setResultadoPorcCredito(resultSet.getString("Var_PorcentPagUniSal"));
				riesgos.setParametroPorcCredito(resultSet.getString("Var_PorPagoUnico"));
				riesgos.setDifLimiteEstabCredito(resultSet.getString("Var_DifLimPagUniSal"));

				return riesgos;
			}
		});
				
		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}
