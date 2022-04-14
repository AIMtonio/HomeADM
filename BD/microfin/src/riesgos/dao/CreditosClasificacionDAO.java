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

public class CreditosClasificacionDAO extends BaseDAO{
	public CreditosClasificacionDAO (){
		super();
	}
	// Consulta para Reporte de Créditos por Clasificación en Excel
	public List reporteCreditosClasificacion(UACIRiesgosBean riesgosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call CREDITOSCLASIFICAREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
	
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosConsumoDAO.listaCredClasificacion",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCLASIFICAREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCarteraAnterior(resultSet.getString("Var_MontoCarteraExc"));
				riesgos.setCreditoConsumo(resultSet.getString("Var_MontoConsumoExc"));
				riesgos.setCreditoComercial(resultSet.getString("Var_MontoComercialExc"));
				riesgos.setCreditoVivienda(resultSet.getString("Var_MontoViviendaExc"));
				riesgos.setSaldoCarteraCredito(resultSet.getString("Var_SaldoCarDiaAnt"));
				
				riesgos.setPorcentualConsumo(resultSet.getString("Var_PorcentualConsumo"));
				riesgos.setPorcentajeConsumo(resultSet.getString("Var_PorcentajeConsumo"));
				riesgos.setLimiteConsumo(resultSet.getString("Var_DifLimiteConsumo"));
				riesgos.setPorcentualComercial(resultSet.getString("Var_PorcentualComer"));
				riesgos.setPorcentajeComercial(resultSet.getString("Var_PorcentajeComer"));
				
				riesgos.setLimiteComercial(resultSet.getString("Var_DifLimiteComer"));
				riesgos.setPorcentualVivienda(resultSet.getString("Var_PorcentualViv"));
				riesgos.setPorcentajeVivienda(resultSet.getString("Var_PorcentajeViv"));
				riesgos.setLimiteVivienda(resultSet.getString("Var_DifLimiteViv"));	
				
				riesgos.setSaldoCartera(resultSet.getString("Var_SaldoCartera"));
				riesgos.setCredConsumo(resultSet.getString("Var_SaldosConsumo"));
				riesgos.setCredComercial(resultSet.getString("Var_SaldosComercial"));
				riesgos.setCredVivienda(resultSet.getString("Var_SaldosVivienda"));
				riesgos.setSaldoTotalCartera(resultSet.getString("Var_SalTotCartera"));
				
				riesgos.setPorcentConsumo(resultSet.getString("Var_PorcentSalConsumo"));
				riesgos.setPorcConsumo(resultSet.getString("Var_PorcentajeConsumo"));
				riesgos.setDiferenciaConsumo(resultSet.getString("Var_DifLimSalConsumo"));
				riesgos.setPorcentComercial(resultSet.getString("Var_PorcentSalComer"));
				riesgos.setPorcComercial(resultSet.getString("Var_PorcentajeComer"));
				
				riesgos.setDiferenciaComercial(resultSet.getString("Var_DifLimSalComer"));
				riesgos.setPorcentVivienda(resultSet.getString("Var_PorcentSalViv"));
				riesgos.setPorcVivienda(resultSet.getString("Var_PorcentajeViv"));
				riesgos.setDiferenciaVivienda(resultSet.getString("Var_DifLimSalViv"));	
	
				return riesgos;
			}
		});
		return matches;
	}
		
	// Consulta para la pantalla de Créditos por Clasificación
	public UACIRiesgosBean consultaCreditosClasificacion(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSCLASIFICAREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosConsumoDAO.consultaCredClasificacion",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCLASIFICAREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCarteraAnterior(resultSet.getString("Var_MontoCartera"));
				riesgos.setCreditoConsumo(resultSet.getString("Var_MontoConsumo"));
				riesgos.setCreditoComercial(resultSet.getString("Var_MontoComercial"));
				riesgos.setCreditoVivienda(resultSet.getString("Var_MontoVivienda"));
				riesgos.setSaldoCarteraCredito(resultSet.getString("Var_SaldoCarDiaAnt"));
				
				riesgos.setPorcentualConsumo(resultSet.getString("Var_PorcentualConsumo"));
				riesgos.setPorcentajeConsumo(resultSet.getString("Var_PorcentajeConsumo"));
				riesgos.setLimiteConsumo(resultSet.getString("Var_DifLimiteConsumo"));
				riesgos.setPorcentualComercial(resultSet.getString("Var_PorcentualComer"));
				riesgos.setPorcentajeComercial(resultSet.getString("Var_PorcentajeComer"));
				
				riesgos.setLimiteComercial(resultSet.getString("Var_DifLimiteComer"));
				riesgos.setPorcentualVivienda(resultSet.getString("Var_PorcentualViv"));
				riesgos.setPorcentajeVivienda(resultSet.getString("Var_PorcentajeViv"));
				riesgos.setLimiteVivienda(resultSet.getString("Var_DifLimiteViv"));	
				
				riesgos.setSaldoCartera(resultSet.getString("Var_SaldoCartera"));
				riesgos.setCredConsumo(resultSet.getString("Var_SaldosConsumo"));
				riesgos.setCredComercial(resultSet.getString("Var_SaldosComercial"));
				riesgos.setCredVivienda(resultSet.getString("Var_SaldosVivienda"));
				riesgos.setSaldoTotalCartera(resultSet.getString("Var_SalTotCartera"));
				
				riesgos.setPorcentConsumo(resultSet.getString("Var_PorcentSalConsumo"));
				riesgos.setPorcConsumo(resultSet.getString("Var_PorcentajeConsumo"));
				riesgos.setDiferenciaConsumo(resultSet.getString("Var_DifLimSalConsumo"));
				riesgos.setPorcentComercial(resultSet.getString("Var_PorcentSalComer"));
				riesgos.setPorcComercial(resultSet.getString("Var_PorcentajeComer"));
				
				riesgos.setDiferenciaComercial(resultSet.getString("Var_DifLimSalComer"));
				riesgos.setPorcentVivienda(resultSet.getString("Var_PorcentSalViv"));
				riesgos.setPorcVivienda(resultSet.getString("Var_PorcentajeViv"));
				riesgos.setDiferenciaVivienda(resultSet.getString("Var_DifLimSalViv"));	

				return riesgos;
			}
		});
				
		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}

}
