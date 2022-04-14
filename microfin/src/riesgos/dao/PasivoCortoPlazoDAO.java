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
 
public class PasivoCortoPlazoDAO extends BaseDAO{
	public PasivoCortoPlazoDAO (){
		super ();
	}
	// Consulta para Reporte de Pasivo a Corto Plazo en Excel
	public List reportePasivoCortoPlazo(UACIRiesgosBean riesgosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call PASIVOCORTOPLAZOREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
	
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"PasivoCortoPlazoDAO.listaPasivoCtoPlzo",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PASIVOCORTOPLAZOREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCapCierreDia(resultSet.getString("Var_MontoCaptadoExc"));
				riesgos.setAhorroMenores(resultSet.getString("Var_AhorroMenorExc"));
				riesgos.setAhorroOrdinario(resultSet.getString("Var_AhorroOrdinarioExc"));
				riesgos.setAhorroVista(resultSet.getString("Var_AhorroVistaExc"));
				riesgos.setMontoPlazo30(resultSet.getString("Var_TotDepInversion"));
				
				riesgos.setResultadoPorcentual(resultSet.getString("Var_PorcentualPasivo"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_PorcPasivCtoPlazo"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimitePasivo"));
				riesgos.setSaldoCaptadoDia(resultSet.getString("Var_SaldoCaptado"));
				riesgos.setSalAhorroMenores(resultSet.getString("Var_SaldoMenor"));
				
				riesgos.setSalAhorroOrdinario(resultSet.getString("Var_SaldoOrdinario"));
				riesgos.setSalAhorroVista(resultSet.getString("Var_SaldoVista"));
				riesgos.setSaldoPlazo30(resultSet.getString("Var_SaldoInversion30"));
				riesgos.setSaldoPorcentual(resultSet.getString("Var_PorcentualSaldo"));
				riesgos.setSaldoPorcentaje(resultSet.getString("Var_PorcPasivCtoPlazo"));
				
				riesgos.setSaldoDiferencia(resultSet.getString("Var_DifLimiteSaldo"));
				
				return riesgos;
			}
		});
		return matches;
	}
	
	// Consulta para la pantalla de Pasivo a Corto Plazo
	public UACIRiesgosBean consultaPasivoCortoPlazo(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call PASIVOCORTOPLAZOREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"PasivoCortoPlazoDAO.consultaPasivoCtoPlzo",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PASIVOCORTOPLAZOREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCapCierreDia(resultSet.getString("Var_MontoCaptado"));
				riesgos.setAhorroMenores(resultSet.getString("Var_AhorroMenor"));
				riesgos.setAhorroOrdinario(resultSet.getString("Var_AhorroOrdinario"));
				riesgos.setAhorroVista(resultSet.getString("Var_AhorroVista"));
				riesgos.setMontoPlazo30(resultSet.getString("Var_TotDepInversion"));
				
				riesgos.setResultadoPorcentual(resultSet.getString("Var_PorcentualPasivo"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_PorcPasivCtoPlazo"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimitePasivo"));
				riesgos.setSaldoCaptadoDia(resultSet.getString("Var_SaldoCaptado"));
				riesgos.setSalAhorroMenores(resultSet.getString("Var_SaldoMenor"));
				
				riesgos.setSalAhorroOrdinario(resultSet.getString("Var_SaldoOrdinario"));
				riesgos.setSalAhorroVista(resultSet.getString("Var_SaldoVista"));
				riesgos.setSaldoPlazo30(resultSet.getString("Var_SaldoInversion30"));
				riesgos.setSaldoPorcentual(resultSet.getString("Var_PorcentualSaldo"));
				riesgos.setSaldoPorcentaje(resultSet.getString("Var_PorcPasivCtoPlazo"));
				
				riesgos.setSaldoDiferencia(resultSet.getString("Var_DifLimiteSaldo"));
				
				return riesgos;
			}
		});
				
		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}
