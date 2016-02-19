# == Schema Information
#
# Table name: games
#
#  id                           :integer          not null, primary key
#  current_round                :integer          default(1)
#  max_rounds                   :integer          default(3)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  sub_round                    :integer          default(1)
#  calculating                  :boolean          default(FALSE)
#  finished                     :boolean          default(FALSE)
#  results_published            :boolean          default(TRUE)
#  low_budget_min_operator      :integer          default(1000)
#  low_budget_max_operator      :integer          default(2000)
#  low_budget_cap_operator      :integer          default(20)
#  high_budget_min_operator     :integer          default(3000)
#  high_budget_max_operator     :integer          default(5000)
#  high_budget_cap_operator     :integer          default(40)
#  low_luxury_min_operator      :integer          default(10000)
#  low_luxury_max_operator      :integer          default(20000)
#  low_luxury_cap_operator      :integer          default(10)
#  high_luxury_min_operator     :integer          default(50000)
#  high_luxury_max_operator     :integer          default(100000)
#  high_luxury_cap_operator     :integer          default(5)
#  low_budget_var_max_operator  :integer          default(20000)
#  low_luxury_var_max_operator  :integer          default(30000)
#  high_budget_var_max_operator :integer          default(50000)
#  high_luxury_var_max_operator :integer          default(80000)
#  low_budget_var_min_operator  :integer          default(10000)
#  low_luxury_var_min_operator  :integer          default(15000)
#  high_budget_var_min_operator :integer          default(20000)
#  high_luxury_var_min_operator :integer          default(30000)
#  low_budget_min_customer      :integer          default(1000)
#  low_budget_max_customer      :integer          default(2000)
#  low_budget_cap_customer      :integer          default(20)
#  high_budget_min_customer     :integer          default(3000)
#  high_budget_max_customer     :integer          default(5000)
#  high_budget_cap_customer     :integer          default(40)
#  low_luxury_min_customer      :integer          default(10000)
#  low_luxury_max_customer      :integer          default(20000)
#  low_luxury_cap_customer      :integer          default(10)
#  high_luxury_min_customer     :integer          default(50000)
#  high_luxury_max_customer     :integer          default(100000)
#  high_luxury_cap_customer     :integer          default(5)
#  low_budget_var_max_customer  :integer          default(20000)
#  low_luxury_var_max_customer  :integer          default(30000)
#  high_budget_var_max_customer :integer          default(50000)
#  high_luxury_var_max_customer :integer          default(80000)
#  low_budget_var_min_customer  :integer          default(10000)
#  low_luxury_var_min_customer  :integer          default(15000)
#  high_budget_var_min_customer :integer          default(20000)
#  high_luxury_var_min_customer :integer          default(30000)
#  low_budget_min_tech          :integer          default(1000)
#  low_budget_max_tech          :integer          default(2000)
#  low_budget_cap_tech          :integer          default(20)
#  high_budget_min_tech         :integer          default(3000)
#  high_budget_max_tech         :integer          default(5000)
#  high_budget_cap_tech         :integer          default(40)
#  low_luxury_min_tech          :integer          default(10000)
#  low_luxury_max_tech          :integer          default(20000)
#  low_luxury_cap_tech          :integer          default(10)
#  high_luxury_min_tech         :integer          default(50000)
#  high_luxury_max_tech         :integer          default(100000)
#  high_luxury_cap_tech         :integer          default(5)
#  low_budget_var_max_tech      :integer          default(20000)
#  low_luxury_var_max_tech      :integer          default(30000)
#  high_budget_var_max_tech     :integer          default(50000)
#  high_luxury_var_max_tech     :integer          default(80000)
#  low_budget_var_min_tech      :integer          default(10000)
#  low_luxury_var_min_tech      :integer          default(15000)
#  high_budget_var_min_tech     :integer          default(20000)
#  high_luxury_var_min_tech     :integer          default(30000)
#  low_budget_min_supply        :integer          default(1000)
#  low_budget_max_supply        :integer          default(2000)
#  low_budget_cap_supply        :integer          default(20)
#  high_budget_min_supply       :integer          default(3000)
#  high_budget_max_supply       :integer          default(5000)
#  high_budget_cap_supply       :integer          default(40)
#  low_luxury_min_supply        :integer          default(10000)
#  low_luxury_max_supply        :integer          default(20000)
#  low_luxury_cap_supply        :integer          default(10)
#  high_luxury_min_supply       :integer          default(50000)
#  high_luxury_max_supply       :integer          default(100000)
#  high_luxury_cap_supply       :integer          default(5)
#  low_budget_var_max_supply    :integer          default(20000)
#  low_luxury_var_max_supply    :integer          default(30000)
#  high_budget_var_max_supply   :integer          default(50000)
#  high_luxury_var_max_supply   :integer          default(80000)
#  low_budget_var_min_supply    :integer          default(10000)
#  low_luxury_var_min_supply    :integer          default(15000)
#  high_budget_var_min_supply   :integer          default(20000)
#  high_luxury_var_min_supply   :integer          default(30000)
#  variable_hash                :text
#  sub_round_decided            :boolean
#  sign_up_open                 :boolean          default(TRUE)
#  bonus_hash                   :text
#  capital_hash                 :text
#  deadline                     :datetime
#  max_sub_rounds               :integer          default(4)
#  bailout_interest             :integer          default(25)
#  split                        :boolean          default(FALSE)
#  setup                        :boolean          default(FALSE)
#

#The Game model is currently a singleton controlling the whole game (see get_game method)
#In the future there might be multiple games running simultaneously

class Game < ActiveRecord::Base
  has_paper_trail :only => [:sub_round]
 
  serialize :variable_hash, Hash
  serialize :bonus_hash, Hash
  serialize :capital_hash, Hash
  has_many :networks
  
  validates :current_round, presence: true
  validates :max_rounds, presence: true


  #Returns the objective of the current round as a string.
  def get_round_objective
    if current_round == 1
      I18n.t :game_objective_1
    elsif current_round == 2
      I18n.t :game_objective_2
    else
      I18n.t :game_objective_3
    end
  end

  #Returns the singleton game model, or creates it if it doesn't exist
  def self.get_game
    game = Game.first
    unless game
      game = Game.create
      game.save
    end
    game
  end

 
  #Calculates the amount of sales made by each network
  def calculate_sales
    markets = Market.all.reject{ |m| m.test }
    markets.each do |m|
      m.complete_sales
    end
  end

  #Ends the current sub-round (aka fiscal year), calculating all the results and moving to next sub-round
  def end_sub_round
    self.update_attribute(:calculating, true)
    Company.set_update_flag(true)
    PaperTrail.enabled = false
    Company.reset_profit
    Company.reset_launches_made
    Company.reset_max_customers
    self.calculate_sales
    #Risk.apply_risks
    Company.save_launches
    Company.calculate_results
    Company.update_market_satisfactions
    #CustomerFacingRole.apply_risk_penalties
    self.results_published = false
    self.sub_round_decided = false
    Game.store_company_reports
    Role.generate_reports
    Company.reset_extras
    Company.set_update_flag(false)
    PaperTrail.enabled = true
    self.sub_round += 1
    self.save!
  end

  

  #Loops through all companies and creates a yearly report for them
  def self.store_company_reports
    Company.all.reject { |c| c.test}.each do |c|
      c.create_report
    end
  end

  #Returns boolean indicating whether the game currently in round given as parameter
  def in_round(round)
    self.current_round == round
  end

  #Accepts the calculated sub round, revealing the results to the players and updating other values such as contract timers and loans
  def accept
    CompanyReport.accept_simulated_reports
    NetworkReport.accept_simulated_reports
    Contract.update_contracts
    Loan.update_loans
    Bid.expire_offers
    #Company.check_bailout
    self.update_attributes(:sub_round_decided => true, :calculating => false, :results_published => true);
  end

  #Declines the calculated sub round, returning everything back to the state they were before starting the sub round
  def revert
    Company.revert_changes
    CompanyReport.delete_simulated_reports
    NetworkReport.delete_simulated_reports
    self.sub_round -= 1
    self.sub_round_decided = true
    self.results_published = true
    self.calculating = false
    self.save!
  end
 
  def create_test_environment(company_amount, user_amount)
    market = Market.create(:name => "Test market")
    market.update_attribute(:test, true)
    company_amount.times do |i|
      companies = []
      CompanyType.all.each do |cp|
        group = Group.create(:test => true)
        company = Company.create(:group_id => group.id)
        company.test = true
        company.company_type_id = cp.id
        test_name = (cp.test_name.present?) ? cp.test_name : cp.name[0..3]
        company.name = test_name + (i+1).to_s
        company.set_starting_capital
        company.initialised = true
        company.capital = 9000000000
        company.save!
        company.set_role(true)
        company.role.update_attribute(:market_id, market.id)

        companies << company

        user_amount.times do |j|
          user = User.new()
          user.name = company.name + "_u" + j.to_s
          user.email = user.name + "@aaltonsbg.com"
          user.password = "PalveluA"
          user.password_confirmation = "PalveluA"
          user.student_number = company.name + j.to_s
          user.department = "NSBG"
          user.group_id = group.id
          user.position = User.positions[j]
          user.test = true
          user.save!
        end
      end
      Game.get_game.create_network(companies)
      companies = []
    end
  end

  def create_network(companies)
    copy_array = companies.dup
    companies.each do |c|
      puts "Testing company type: " + c.company_type.name
      copy_array.each do |d|
        if c.company_type.need?(d.company_type) || d.company_type.need?(c.company_type)
          sender_company = (d.company_type.need?(c.company_type)) ? c : d
          target_company = (sender_company == c) ? d : c
          process = ContractProcess.find_or_create_from_offer(target_company, sender_company.group.users.first)
          process.update_attribute(:initiator_id, target_company.group.users.first.id)
          bid = Bid.new()
          bid.amount = 1
          bid.message = "Test bid"
          bid.penalty = 0
          bid.status = Bid.accepted
          bid.read = true
          bid.sender = sender_company
          bid.receiver = target_company
          bid.contract_process_id = process.id

          if bid.marketing_present?
            marketing_max = CompanyType.find_by_marketing_produce(true).limit_hash["11_marketing_max_size"]
            bid.marketing_amount = marketing_max
          end
          if bid.unit_present?
            unit_max = CompanyType.find_by_unit_produce(true).limit_hash["11_unit_max_size"]
            bid.unit_amount = unit_max
          end

          if bid.capacity_present?
            capacity_max = CompanyType.find_by_capacity_produce(true).limit_hash["11_capacity_max_size"]
            bid.capacity_amount = capacity_max
          end

          bid.create_offer
          bid.save!
          bid.sign_contract!

        end
      end
      copy_array.delete(c)
    end
  end

 def destroy_test_environment
   Company.where(:test => true).each do |c|
     c.destroy
   end
   Group.where(:test => true).each do |g|
     g.destroy
   end
   User.where(:test => true).each do |u|
     u.destroy
   end
   Market.where(:test => true).each do |m|
     m.destroy
   end
 end

 #Run a sales test for a test network. Returns an array of profits for different
 #launch amounts and prices. All other needed values are taken from the test network.
 #If consider_others is set to true, other test networks will be considered for the results
 def run_tests(consider_others)
   step_size = (consider_others) ? 4 : 5
   company_type_id = CompanyType.find_by_price_set(true).id
   company = Company.where(:test => true, :company_type_id => company_type_id).order(:id).first
   return if company.nil?

   market = Market.find_by_test(true)
   return if market.customer_amount.nil?
   array = []
   array << ["ID", "Launches", "Price", "Profit", "Size"]

   unit_max = CompanyType.where(:unit_produce => true).first.limit_hash["11_unit_max_size"].to_i
   price_max = market.variables["exp1"].to_i * 3
   unit_step = (unit_max.to_f / step_size).to_i
   price_step = (price_max.to_f / step_size).to_i
   unit = unit_step
   price = price_step
   while unit_max >= unit
     while price_max >= price
       inside_array = []
       inside_array << ""
       inside_array << unit
       inside_array << price
       profit = market.test_sales(price, unit, company, consider_others).to_i
       inside_array << profit
       inside_array << profit.abs
       array << inside_array
       price += price_step
     end
     unit += unit_step
     price = price_step
   end
   return array
 end



  private

  
end
