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

public class CarteraVencidaDAO extends BaseDAO {

	public CarteraVencidaDAO() {
		super();
	}
	
	// Consulta para Reporte de Cartera Vencida en Excel
	public List reporteCarteraVencida(UACIRiesgosBean riesgosBean,int tipoLista) {
		String query = "call CARTERAVENCIDAREP(?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CarteraVencidaDAO.listaCarteraVencida",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARTERAVENCIDAREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCarteraCredVen(resultSet.getString("Var_MontoCreditoVen"));
				riesgos.setSaldoCarteraCreVen(resultSet.getString("Var_SalTotCarVen"));
				riesgos.setSaldoCarteraCredito(resultSet.getString("Var_SaldoTotCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("Var_PorcentCarVenAnt"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_PorCarteraVen"));
				
				riesgos.setSaldoCarteraCreVencida(resultSet.getString("Var_SalTotCarVen"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimCarVenAnt"));
				riesgos.setResultadoPorcCar(resultSet.getString("Var_PorcentCarVenAcum"));
				riesgos.setParametroPorcCar(resultSet.getString("Var_PorCarteraVen"));
				riesgos.setDifLimiteEstabCar(resultSet.getString("Var_DifLimCarVenAcum"));

				return riesgos;
				}
			});
			return matches;
		}
	
	// Consulta para la pantalla de Cartera Vencida
	public UACIRiesgosBean consultaCarteraVencida(UACIRiesgosBean riesgosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CARTERAVENCIDAREP(?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(riesgosBean.getFechaOperacion()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CarteraVencidaDAO.consultaCarteraVen",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARTERAVENCIDAREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UACIRiesgosBean riesgos = new UACIRiesgosBean();
				riesgos.setMontoCarteraCredVen(resultSet.getString("Var_MontoCreditoVen"));
				riesgos.setSaldoCarteraCreVen(resultSet.getString("Var_SalTotCarVen"));
				riesgos.setSaldoCarteraCredito(resultSet.getString("Var_SaldoTotCredito"));
				riesgos.setResultadoPorcentual(resultSet.getString("Var_PorcentCarVenAnt"));
				riesgos.setParametroPorcentaje(resultSet.getString("Var_PorCarteraVen"));
				
				riesgos.setSaldoCarteraCreVencida(resultSet.getString("Var_SalTotCarVen"));
				riesgos.setDifLimiteEstablecido(resultSet.getString("Var_DifLimCarVenAnt"));
				riesgos.setResultadoPorcCar(resultSet.getString("Var_PorcentCarVenAcum"));
				riesgos.setParametroPorcCar(resultSet.getString("Var_PorCarteraVen"));
				riesgos.setDifLimiteEstabCar(resultSet.getString("Var_DifLimCarVenAcum"));
				
				
				return riesgos;
	
			}
		});
				
		return matches.size() > 0 ? (UACIRiesgosBean) matches.get(0) : null;
	}
}
