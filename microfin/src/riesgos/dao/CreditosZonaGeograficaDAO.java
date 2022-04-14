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
 
public class CreditosZonaGeograficaDAO extends BaseDAO{
	public CreditosZonaGeograficaDAO (){
		super ();
	}
	// Consulta para Reporte de Créditos por Zona Geográfica en Excel
	public List reporteCredZonaGeografica(UACIRiesgosBean riesgosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call CREDZONAGEOGRAFICAREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),
	
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosZonaGeograficaDAO.listaCredZonaGeo",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDZONAGEOGRAFICAREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCarteraZona(resultSet.getString("Var_MontoCarteraExc"));
				riesgos.setCarteraPuebla(resultSet.getString("Var_MontoPueblaExc"));
				riesgos.setCarteraOaxaca(resultSet.getString("Var_MontoOaxacaExc"));
				riesgos.setCarteraVeracruz(resultSet.getString("Var_MontoVeracruzExc"));
				riesgos.setSaldoCarteraCredito(resultSet.getString("Var_SaldoCarDiaAnt"));
				
				riesgos.setPorcentualOaxaca(resultSet.getString("Var_PorcentualOax"));
				riesgos.setPorcentajeOaxaca(resultSet.getString("Var_PorcentajeOax"));
				riesgos.setLimiteOaxaca(resultSet.getString("Var_DifLimiteOax"));
				riesgos.setPorcentualPuebla(resultSet.getString("Var_PorcentualPue"));
				riesgos.setPorcentajePuebla(resultSet.getString("Var_PorcentajePue"));
				
				riesgos.setLimitePuebla(resultSet.getString("Var_DifLimitePue"));
				riesgos.setPorcentualVeracruz(resultSet.getString("Var_PorcentualVer"));
				riesgos.setPorcentajeVeracruz(resultSet.getString("Var_PorcentajeVer"));
				riesgos.setLimiteVeracruz(resultSet.getString("Var_DifLimiteVer"));	
				
				riesgos.setSaldoCarteraZona(resultSet.getString("Var_SaldosCartera"));
				riesgos.setCarteraPue(resultSet.getString("Var_SaldosCredPue"));
				riesgos.setCarteraOax(resultSet.getString("Var_SaldosCredOax"));
				riesgos.setCarteraVer(resultSet.getString("Var_SaldosCredVer"));
				riesgos.setSaldoTotalCartera(resultSet.getString("Var_SalTotCartera"));
				
				riesgos.setPorcentualOax(resultSet.getString("Var_PorcentualSalOax"));
				riesgos.setPorcentajeOax(resultSet.getString("Var_PorcentajeOax"));
				riesgos.setLimiteOax(resultSet.getString("Var_DifLimiteSalOax"));
				riesgos.setPorcentualPue(resultSet.getString("Var_PorcentualSalPue"));
				riesgos.setPorcentajePue(resultSet.getString("Var_PorcentajePue"));
				
				riesgos.setLimitePue(resultSet.getString("Var_DifLimiteSalPue"));
				riesgos.setPorcentualVer(resultSet.getString("Var_PorcentualSalVer"));
				riesgos.setPorcentajeVer(resultSet.getString("Var_PorcentajeVer"));
				riesgos.setLimiteVer(resultSet.getString("Var_DifLimiteSalVer"));	
	
				return riesgos;
			}
		});
		return matches;
	}
			
	// Consulta para la pantalla de Créditos por Zona Geográfica
	public UACIRiesgosBean consultaCredZonaGeografica(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDZONAGEOGRAFICAREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosZonaGeograficaDAO.consultaCredZonaGeo",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDZONAGEOGRAFICAREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCarteraZona(resultSet.getString("Var_MontoCartera"));
				riesgos.setCarteraPuebla(resultSet.getString("Var_MontoPuebla"));
				riesgos.setCarteraOaxaca(resultSet.getString("Var_MontoOaxaca"));
				riesgos.setCarteraVeracruz(resultSet.getString("Var_MontoVeracruz"));
				riesgos.setSaldoCarteraCredito(resultSet.getString("Var_SaldoCarDiaAnt"));
				
				riesgos.setPorcentualOaxaca(resultSet.getString("Var_PorcentualOax"));
				riesgos.setPorcentajeOaxaca(resultSet.getString("Var_PorcentajeOax"));
				riesgos.setLimiteOaxaca(resultSet.getString("Var_DifLimiteOax"));
				riesgos.setPorcentualPuebla(resultSet.getString("Var_PorcentualPue"));
				riesgos.setPorcentajePuebla(resultSet.getString("Var_PorcentajePue"));
				
				riesgos.setLimitePuebla(resultSet.getString("Var_DifLimitePue"));
				riesgos.setPorcentualVeracruz(resultSet.getString("Var_PorcentualVer"));
				riesgos.setPorcentajeVeracruz(resultSet.getString("Var_PorcentajeVer"));
				riesgos.setLimiteVeracruz(resultSet.getString("Var_DifLimiteVer"));	
				
				riesgos.setSaldoCarteraZona(resultSet.getString("Var_SaldosCartera"));
				riesgos.setCarteraPue(resultSet.getString("Var_SaldosCredPue"));
				riesgos.setCarteraOax(resultSet.getString("Var_SaldosCredOax"));
				riesgos.setCarteraVer(resultSet.getString("Var_SaldosCredVer"));
				riesgos.setSaldoTotalCartera(resultSet.getString("Var_SalTotCartera"));
				
				riesgos.setPorcentualOax(resultSet.getString("Var_PorcentualSalOax"));
				riesgos.setPorcentajeOax(resultSet.getString("Var_PorcentajeOax"));
				riesgos.setLimiteOax(resultSet.getString("Var_DifLimiteSalOax"));
				riesgos.setPorcentualPue(resultSet.getString("Var_PorcentualSalPue"));
				riesgos.setPorcentajePue(resultSet.getString("Var_PorcentajePue"));
				
				riesgos.setLimitePue(resultSet.getString("Var_DifLimiteSalPue"));
				riesgos.setPorcentualVer(resultSet.getString("Var_PorcentualSalVer"));
				riesgos.setPorcentajeVer(resultSet.getString("Var_PorcentajeVer"));
				riesgos.setLimiteVer(resultSet.getString("Var_DifLimiteSalVer"));	
				
				return riesgos;
			}
		});
				
		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}
