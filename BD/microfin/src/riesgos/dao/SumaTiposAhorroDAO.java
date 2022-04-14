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

public class SumaTiposAhorroDAO extends BaseDAO{
	public SumaTiposAhorroDAO (){
		super();
	}
	
	
	// Consulta para el reporte de Suma Tipos Ahorro en Excel
	public List reporteSumaTiposAhorro(UACIRiesgosBean riesgosBean,int tipoLista) {
		String query = "call SUMASTIPOAHORROREP(?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"SumaTiposAhorroDAO.listaTipoAhorro",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUMASTIPOAHORROREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCaptadoDia(resultSet.getString("Var_MontoCapDiaAntExc"));
				riesgos.setAhorroMenores(resultSet.getString("Var_AhorroMenorExc"));
				riesgos.setAhorroOrdinario(resultSet.getString("Var_AhorroOrdinarioExc"));
				riesgos.setAhorroVista(resultSet.getString("Var_AhorroVistaExc"));
				riesgos.setCuentaSinMov(resultSet.getString("Var_MontoCtasSinMov"));

				riesgos.setDepositoInversion(resultSet.getString("Var_AhorroPlazo"));
				riesgos.setMontoPlazo30(resultSet.getString("Var_MontoPlazo30"));
				riesgos.setMontoPlazo60(resultSet.getString("Var_MontoPlazo60"));
				riesgos.setMontoPlazo90(resultSet.getString("Var_MontoPlazo90"));
				riesgos.setMontoPlazo120(resultSet.getString("Var_MontoPlazo120"));

				riesgos.setMontoPlazo180(resultSet.getString("Var_MontoPlazo180"));
				riesgos.setMontoPlazo360(resultSet.getString("Var_MontoPlazo360"));
				riesgos.setMontoInteresMensual(resultSet.getString("Var_InteresPlazo")); 
				riesgos.setMontoVistaOrdinario(resultSet.getString("Var_MontoVistaOrd")); 
				riesgos.setPorcentualAhorroVista(resultSet.getString("Var_PorcentVistaOrd"));
				
				riesgos.setMontoInversion(resultSet.getString("Var_MontoInversion"));
				riesgos.setPorcentualInversiones(resultSet.getString("Var_PorcentInversion"));
				riesgos.setSaldoCaptadoDia(resultSet.getString("Var_SaldoCapDiaAnt"));
				riesgos.setSalAhorroMenores(resultSet.getString("Var_SaldoMenor"));
				riesgos.setSalAhorroOrdinario(resultSet.getString("Var_SaldoOrdinario"));

				riesgos.setSalAhorroVista(resultSet.getString("Var_SaldoVista"));
				riesgos.setSalCuentaSinMov(resultSet.getString("Var_SalCtasSinMov"));
				riesgos.setSaldDepInversion(resultSet.getString("Var_SaldoInversion"));
				riesgos.setSaldoPlazo30(resultSet.getString("Var_SaldoInversion30"));
				riesgos.setSaldoPlazo60(resultSet.getString("Var_SaldoInversion60"));
				
				riesgos.setSaldoPlazo90(resultSet.getString("Var_SaldoInversion90"));
				riesgos.setSaldoPlazo120(resultSet.getString("Var_SaldoInversion120"));
				riesgos.setSaldoPlazo180(resultSet.getString("Var_SaldoInversion180"));
				riesgos.setSaldoPlazo360(resultSet.getString("Var_SaldoInversion360"));
				riesgos.setSaldoInteresMensual(resultSet.getString("Var_SaldoIntInversion"));

				riesgos.setSaldoVistaOrdinario(resultSet.getString("Var_SaldoVistaOrd"));
				riesgos.setSalPorcentualAhorroVista(resultSet.getString("Var_PorcentSalVistaOrd"));
				riesgos.setSaldoInversion(resultSet.getString("Var_SaldoInversiones"));
				riesgos.setSalPorcentualInversiones(resultSet.getString("Var_PorcentSaldoInv"));

				return riesgos;
			}
		});
		return matches;
	}
	
	// Consulta para la pantalla de Suma Tipos Ahorro
	public UACIRiesgosBean consultaSumasTiposAhorro(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SUMASTIPOAHORROREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"SumaTiposAhorroDAO.consultaTipoAhorro",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUMASTIPOAHORROREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCaptadoDia(resultSet.getString("Var_MontoCapDiaAnt"));
				riesgos.setAhorroMenores(resultSet.getString("Var_AhorroMenor"));
				riesgos.setAhorroOrdinario(resultSet.getString("Var_AhorroOrdinario"));
				riesgos.setAhorroVista(resultSet.getString("Var_AhorroVista"));
				riesgos.setCuentaSinMov(resultSet.getString("Var_MontoCtasSinMov"));

				riesgos.setDepositoInversion(resultSet.getString("Var_AhorroPlazo"));
				riesgos.setMontoPlazo30(resultSet.getString("Var_MontoPlazo30"));
				riesgos.setMontoPlazo60(resultSet.getString("Var_MontoPlazo60"));
				riesgos.setMontoPlazo90(resultSet.getString("Var_MontoPlazo90"));
				riesgos.setMontoPlazo120(resultSet.getString("Var_MontoPlazo120"));

				riesgos.setMontoPlazo180(resultSet.getString("Var_MontoPlazo180"));
				riesgos.setMontoPlazo360(resultSet.getString("Var_MontoPlazo360"));
				riesgos.setMontoInteresMensual(resultSet.getString("Var_InteresPlazo")); 
				riesgos.setMontoVistaOrdinario(resultSet.getString("Var_MontoVistaOrd")); 
				riesgos.setPorcentualAhorroVista(resultSet.getString("Var_PorcentVistaOrd"));
				
				riesgos.setMontoInversion(resultSet.getString("Var_MontoInversion"));
				riesgos.setPorcentualInversiones(resultSet.getString("Var_PorcentInversion"));
				riesgos.setSaldoCaptadoDia(resultSet.getString("Var_SaldoCapDiaAnt"));
				riesgos.setSalAhorroMenores(resultSet.getString("Var_SaldoMenor"));
				riesgos.setSalAhorroOrdinario(resultSet.getString("Var_SaldoOrdinario"));

				riesgos.setSalAhorroVista(resultSet.getString("Var_SaldoVista"));
				riesgos.setSalCuentaSinMov(resultSet.getString("Var_SalCtasSinMov"));
				riesgos.setSaldDepInversion(resultSet.getString("Var_SaldoInversion"));
				riesgos.setSaldoPlazo30(resultSet.getString("Var_SaldoInversion30"));
				riesgos.setSaldoPlazo60(resultSet.getString("Var_SaldoInversion60"));
				
				riesgos.setSaldoPlazo90(resultSet.getString("Var_SaldoInversion90"));
				riesgos.setSaldoPlazo120(resultSet.getString("Var_SaldoInversion120"));
				riesgos.setSaldoPlazo180(resultSet.getString("Var_SaldoInversion180"));
				riesgos.setSaldoPlazo360(resultSet.getString("Var_SaldoInversion360"));
				riesgos.setSaldoInteresMensual(resultSet.getString("Var_SaldoIntInversion"));

				riesgos.setSaldoVistaOrdinario(resultSet.getString("Var_SaldoVistaOrd"));
				riesgos.setSalPorcentualAhorroVista(resultSet.getString("Var_PorcentSalVistaOrd"));
				riesgos.setSaldoInversion(resultSet.getString("Var_SaldoInversiones"));
				riesgos.setSalPorcentualInversiones(resultSet.getString("Var_PorcentSaldoInv"));


				return riesgos;
			}
		});
				
		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}
