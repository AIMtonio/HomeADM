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
 
public class SumaAhorroInversionDAO extends BaseDAO{
	
	public SumaAhorroInversionDAO (){
		super ();
	}
	// Consulta para Reporte de Sumas de Ahorro e Inversión en Excel
	public List reporteSumaAhorroInversion(UACIRiesgosBean riesgosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call SUMAHORROINVERSIONREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
	
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"SumaAhorroInversionDAO.listaSumAhoInv",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUMAHORROINVERSIONREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCaptadoDia(resultSet.getString("Var_MontoCaptadoExc"));
				riesgos.setAhorroOrdinario(resultSet.getString("Var_AhoOrdinarioSocioExc"));
				riesgos.setAhorroVista(resultSet.getString("Var_AhoVistaSocioExc"));
				riesgos.setDepositoInversion(resultSet.getString("Var_InversionSocio"));
				riesgos.setCapitalNetoMensual(resultSet.getString("Var_CapitalNeto"));

				riesgos.setResultadoPorcentual(resultSet.getString("Var_PorcentSumAhoInv"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_PorcSumAhoInv"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimiteSumAhoInv"));
				riesgos.setSaldoCaptadoDia(resultSet.getString("Var_SaldoCaptado"));
				riesgos.setSalAhorroOrdinario(resultSet.getString("Var_SalAhoOrdinSocio"));

				riesgos.setSalAhorroVista(resultSet.getString("Var_SalAhoVistaSocio"));
				riesgos.setSaldDepInversion(resultSet.getString("Var_SalInversionSocio"));
				riesgos.setSalCapitalNetoMensual(resultSet.getString("Var_CapitalNeto"));
				riesgos.setSaldoPorcentual(resultSet.getString("Var_PorcentualSaldo"));
				riesgos.setSaldoPorcentaje(resultSet.getString("Var_PorcSumAhoInv"));
				riesgos.setSaldoDiferencia(resultSet.getString("Var_DifLimiteSaldo"));

				return riesgos;
			}
		});
		return matches;
	}
	
	// Consulta para la pantalla de Suma Ahorro Inversion
	public UACIRiesgosBean consultaSumaAhorroInversion(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SUMAHORROINVERSIONREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"SumaAhorroInversionDAO.consultaSumAhoInv",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUMAHORROINVERSIONREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCaptadoDia(resultSet.getString("Var_MontoCaptado"));
				riesgos.setAhorroOrdinario(resultSet.getString("Var_AhoOrdinarioSocio"));
				riesgos.setAhorroVista(resultSet.getString("Var_AhoVistaSocio"));
				riesgos.setDepositoInversion(resultSet.getString("Var_InversionSocio"));
				riesgos.setCapitalNetoMensual(resultSet.getString("Var_CapitalNeto"));

				riesgos.setResultadoPorcentual(resultSet.getString("Var_PorcentSumAhoInv"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_PorcSumAhoInv"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimiteSumAhoInv"));
				riesgos.setSaldoCaptadoDia(resultSet.getString("Var_SaldoCaptado"));
				riesgos.setSalAhorroOrdinario(resultSet.getString("Var_SalAhoOrdinSocio"));

				riesgos.setSalAhorroVista(resultSet.getString("Var_SalAhoVistaSocio"));
				riesgos.setSaldDepInversion(resultSet.getString("Var_SalInversionSocio"));
				riesgos.setSalCapitalNetoMensual(resultSet.getString("Var_CapitalNeto"));
				riesgos.setSaldoPorcentual(resultSet.getString("Var_PorcentualSaldo"));
				riesgos.setSaldoPorcentaje(resultSet.getString("Var_PorcSumAhoInv"));
				riesgos.setSaldoDiferencia(resultSet.getString("Var_DifLimiteSaldo"));
				
				return riesgos;
			}
		});
				
		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}
