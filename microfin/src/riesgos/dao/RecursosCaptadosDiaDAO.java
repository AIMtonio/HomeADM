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
 
public class RecursosCaptadosDiaDAO extends BaseDAO {

	public RecursosCaptadosDiaDAO() {
		super();
	}
	// Consulta para Reporte de Recursos Captados al Día en Excel
	public List reporteCaptadosDia(UACIRiesgosBean riesgosBean,int tipoLista) {
		String query = "call CAPTADOSDIAREP(?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"RecursosCaptadosDiaDAO.listaCaptadosDia",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAPTADOSDIAREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCaptadoDia(resultSet.getString("Var_MontoCapDiaAntExc"));
				riesgos.setAhorroPlazo(resultSet.getString("Var_AhorroPlazoExc"));
				riesgos.setAhorroMenores(resultSet.getString("Var_AhorroMenorExc"));
				riesgos.setAhorroOrdinario(resultSet.getString("Var_AhorroOrdinarioExc"));
				riesgos.setAhorroVista(resultSet.getString("Var_AhorroVistaExc"));
				
				riesgos.setDepositoInversion(resultSet.getString("Var_TotDepInversion"));
				riesgos.setMontoPlazo30(resultSet.getString("Var_MontoPlazo30"));
				riesgos.setMontoPlazo60(resultSet.getString("Var_MontoPlazo60"));
				riesgos.setMontoPlazo90(resultSet.getString("Var_MontoPlazo90"));
				riesgos.setMontoPlazo120(resultSet.getString("Var_MontoPlazo120"));
				
				riesgos.setMontoPlazo180(resultSet.getString("Var_MontoPlazo180"));
				riesgos.setMontoPlazo360(resultSet.getString("Var_MontoPlazo360"));
				riesgos.setCaptacionTradicional(resultSet.getString("Var_TotalCaptacionExc"));
				riesgos.setCarteraDiaAnterior(resultSet.getString("Var_MontoCarDiaAntExc"));
				riesgos.setCarteraCredVigente(resultSet.getString("Var_MontoCarteraVigExc"));
				
				riesgos.setCarteraCredVencida(resultSet.getString("Var_MontoCarteraVenExc"));
				riesgos.setTotalCarteraCredito(resultSet.getString("Var_SaldoTotCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("Var_PorcentualCapDia"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_PorCaptadoDia"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimCapDia"));
				
				riesgos.setSaldoCaptadoDia(resultSet.getString("Var_SaldoCapDiaAnt"));
				riesgos.setSalAhorroPlazo(resultSet.getString("Var_SaldoAhorroPlazo"));
				riesgos.setSalAhorroMenores(resultSet.getString("Var_SaldoMenor"));
				riesgos.setSalAhorroOrdinario(resultSet.getString("Var_SaldoOrdinario"));
				riesgos.setSalAhorroVista(resultSet.getString("Var_SaldoVista"));
				
				riesgos.setSaldDepInversion(resultSet.getString("Var_SaldoInversion"));
				riesgos.setSaldoPlazo30(resultSet.getString("Var_SaldoInversion30"));
				riesgos.setSaldoPlazo60(resultSet.getString("Var_SaldoInversion60"));
				riesgos.setSaldoPlazo90(resultSet.getString("Var_SaldoInversion90"));
				riesgos.setSaldoPlazo120(resultSet.getString("Var_SaldoInversion120"));
				
				riesgos.setSaldoPlazo180(resultSet.getString("Var_SaldoInversion180"));
				riesgos.setSaldoPlazo360(resultSet.getString("Var_SaldoInversion360"));
				riesgos.setSalCapTradicional(resultSet.getString("Var_SaldoCaptado"));
				riesgos.setSaldoCartera(resultSet.getString("Var_SaldosCreditos"));
				riesgos.setSaldoCredVigente(resultSet.getString("Var_SaldosCredVig"));
				
				riesgos.setSaldoCredVencida(resultSet.getString("Var_SaldosCredVen"));
				riesgos.setSaldoTotalCartera(resultSet.getString("Var_SaldoTotCredito"));
				riesgos.setSaldoPorcentual(resultSet.getString("Var_PorcentualSaldo"));
				riesgos.setSaldoPorcentaje(resultSet.getString("Var_PorCaptadoDia"));
				riesgos.setSaldoDiferencia(resultSet.getString("Var_DifLimiteSaldo"));
				
				riesgos.setMontoInteresMensual(resultSet.getString("Var_InteresPlazo"));
				riesgos.setSaldoInteresMensual(resultSet.getString("Var_SaldoIntInversion"));
				riesgos.setCuentaSinMov(resultSet.getString("Var_MontoCtasSinMov"));
				riesgos.setSalCuentaSinMov(resultSet.getString("Var_SalCtasSinMov"));
				
				return riesgos;
			}
		});
		return matches;
	}
	
	// Consulta para la pantalla de Recursos Captados al Día
	public UACIRiesgosBean consultaRecursoCaptadoDia(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CAPTADOSDIAREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"RecursosCaptadosDiaDAO.consultaCaptadosDia",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAPTADOSDIAREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCaptadoDia(resultSet.getString("Var_MontoCapDiaAnt"));
				riesgos.setAhorroPlazo(resultSet.getString("Var_AhorroPlazo"));
				riesgos.setAhorroMenores(resultSet.getString("Var_AhorroMenor"));
				riesgos.setAhorroOrdinario(resultSet.getString("Var_AhorroOrdinario"));
				riesgos.setAhorroVista(resultSet.getString("Var_AhorroVista"));
				
				riesgos.setDepositoInversion(resultSet.getString("Var_TotDepInversion"));
				riesgos.setMontoPlazo30(resultSet.getString("Var_MontoPlazo30"));
				riesgos.setMontoPlazo60(resultSet.getString("Var_MontoPlazo60"));
				riesgos.setMontoPlazo90(resultSet.getString("Var_MontoPlazo90"));
				riesgos.setMontoPlazo120(resultSet.getString("Var_MontoPlazo120"));
				
				riesgos.setMontoPlazo180(resultSet.getString("Var_MontoPlazo180"));
				riesgos.setMontoPlazo360(resultSet.getString("Var_MontoPlazo360"));
				riesgos.setCaptacionTradicional(resultSet.getString("Var_TotalCaptacion"));
				riesgos.setCarteraDiaAnterior(resultSet.getString("Var_MontoCarDiaAnt"));
				riesgos.setCarteraCredVigente(resultSet.getString("Var_MontoCarteraVig"));
				
				riesgos.setCarteraCredVencida(resultSet.getString("Var_MontoCarteraVen"));
				riesgos.setTotalCarteraCredito(resultSet.getString("Var_SaldoTotCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("Var_PorcentualCapDia"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_PorCaptadoDia"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimCapDia"));
				
				riesgos.setSaldoCaptadoDia(resultSet.getString("Var_SaldoCapDiaAnt"));
				riesgos.setSalAhorroPlazo(resultSet.getString("Var_SaldoAhorroPlazo"));
				riesgos.setSalAhorroMenores(resultSet.getString("Var_SaldoMenor"));
				riesgos.setSalAhorroOrdinario(resultSet.getString("Var_SaldoOrdinario"));
				riesgos.setSalAhorroVista(resultSet.getString("Var_SaldoVista"));
				
				riesgos.setSaldDepInversion(resultSet.getString("Var_SaldoInversion"));
				riesgos.setSaldoPlazo30(resultSet.getString("Var_SaldoInversion30"));
				riesgos.setSaldoPlazo60(resultSet.getString("Var_SaldoInversion60"));
				riesgos.setSaldoPlazo90(resultSet.getString("Var_SaldoInversion90"));
				riesgos.setSaldoPlazo120(resultSet.getString("Var_SaldoInversion120"));
				
				riesgos.setSaldoPlazo180(resultSet.getString("Var_SaldoInversion180"));
				riesgos.setSaldoPlazo360(resultSet.getString("Var_SaldoInversion360"));
				riesgos.setSalCapTradicional(resultSet.getString("Var_SaldoCaptado"));
				riesgos.setSaldoCartera(resultSet.getString("Var_SaldosCreditos"));
				riesgos.setSaldoCredVigente(resultSet.getString("Var_SaldosCredVig"));
				
				riesgos.setSaldoCredVencida(resultSet.getString("Var_SaldosCredVen"));
				riesgos.setSaldoTotalCartera(resultSet.getString("Var_SaldoTotCredito"));
				riesgos.setSaldoPorcentual(resultSet.getString("Var_PorcentualSaldo"));
				riesgos.setSaldoPorcentaje(resultSet.getString("Var_PorCaptadoDia"));
				riesgos.setSaldoDiferencia(resultSet.getString("Var_DifLimiteSaldo"));
				
				riesgos.setMontoInteresMensual(resultSet.getString("Var_InteresPlazo"));
				riesgos.setSaldoInteresMensual(resultSet.getString("Var_SaldoIntInversion"));
				riesgos.setCuentaSinMov(resultSet.getString("Var_MontoCtasSinMov"));
				riesgos.setSalCuentaSinMov(resultSet.getString("Var_SalCtasSinMov"));
				
				return riesgos;
	
			}
		});
				
		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}
