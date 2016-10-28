require 'spec_helper'
require 'byebug'

feature "Approving a lab" do

  given!(:lab_admin) { FactoryGirl.create(:user) }
  let!(:referee) { FactoryGirl.create(:lab, workflow_state: :approved, creator: lab_admin) }
  let!(:referee_employee) { FactoryGirl.create(:employee, user: lab_admin, lab: referee) }

  #create the three referees
  given!(:lab_admin_arc) { FactoryGirl.create(:user) }
  given!(:lab_admin_san) { FactoryGirl.create(:user) }
  given!(:lab_admin_ath) { FactoryGirl.create(:user) }

  let!(:arc) { FactoryGirl.create(:lab, name: "Fabbrica Arca", slug: "fabbricaarca", workflow_state: :approved, creator: lab_admin_arc) }
  let!(:san) { FactoryGirl.create(:lab, name: "SanjoTec Design Lab", slug: "sanjotecdesignlab", workflow_state: :approved, creator: lab_admin_san) }
  let!(:ath) { FactoryGirl.create(:lab, name: "Athens Making Lab", slug: "athensmakinglab", workflow_state: :approved, creator: lab_admin_ath) }

  let!(:lab) { FactoryGirl.create(:lab, referee: referee) }
  let!(:new_lab) { FactoryGirl.create(:lab, referee: referee) }

  background do
    lab_admin.verify!
    lab_admin_arc.verify!
    lab_admin_san.verify!
    lab_admin_ath.verify!
    lab_admin_arc.add_role :admin, arc
    lab_admin_san.add_role :admin, san
    lab_admin_ath.add_role :admin, ath
  end

  scenario "as an admin" do
    lab = FactoryGirl.create(:lab, referee: referee)
    sign_in_superadmin
    visit backstage_lab_path(lab)
    click_button "Approve"
    expect(page).to have_content("Lab approved")
  end

  scenario "approve lab with new process as an admin" do
    new_lab = FactoryGirl.create(:lab, referee: referee)
    sign_in_superadmin
    visit backstage_lab_path(new_lab)
    click_button "Approve"
    expect(page).to have_content("Lab approved")
  end

  scenario "referees approve-reject-approve lab" do
    new_lab = FactoryGirl.create(:lab, referee: referee)
    new_lab.referee_approval_processes.create(referee_lab: arc)
    new_lab.referee_approval_processes.create(referee_lab: san)
    new_lab.referee_approval_processes.create(referee_lab: ath)

    sign_in lab_admin_arc
    expect(lab_admin_arc.is_referee?).to eq(true)
    visit backstage_lab_path(new_lab)
    click_button "Referee approves"
    expect(page).to have_content("Lab referee approved")
    updated_lab = Lab.find(new_lab.id)
    expect(updated_lab.workflow_state).to eq("referee_approval")
    sign_out lab_admin_arc

    sign_in lab_admin_san
    expect(lab_admin_san.is_referee?).to eq(true)
    visit backstage_lab_path(new_lab)
    click_button "Referee rejects"
    expect(page).to have_content("Lab referee rejected")
    updated_lab = Lab.find(new_lab.id)
    expect(updated_lab.workflow_state).to eq("undecided")
    sign_out lab_admin_san

    sign_in lab_admin_ath
    expect(lab_admin_ath.is_referee?).to eq(true)
    visit backstage_lab_path(new_lab)
    click_button "Referee approves"
    expect(page).to have_content("Lab referee approved")
    updated_lab = Lab.find(new_lab.id)
    expect(updated_lab.workflow_state).to eq("approved")
  end

  scenario "referees reject-reject lab" do
    new_lab = FactoryGirl.create(:lab, referee: referee)
    new_lab.referee_approval_processes.create(referee_lab: arc)
    new_lab.referee_approval_processes.create(referee_lab: san)
    new_lab.referee_approval_processes.create(referee_lab: ath)

    sign_in lab_admin_arc
    expect(lab_admin_arc.is_referee?).to eq(true)
    visit backstage_lab_path(new_lab)
    click_button "Referee rejects"
    expect(page).to have_content("Lab referee rejected")
    updated_lab = Lab.find(new_lab.id)
    expect(updated_lab.workflow_state).to eq("might_need_review")
    sign_out lab_admin_arc

    sign_in lab_admin_san
    expect(lab_admin_san.is_referee?).to eq(true)
    visit backstage_lab_path(new_lab)
    click_button "Referee rejects"
    expect(page).to have_content("Lab referee rejected")
    updated_lab = Lab.find(new_lab.id)
    expect(updated_lab.workflow_state).to eq("rejected")
    sign_out lab_admin_san
  end

  scenario "referees approve-approve lab" do
    new_lab = FactoryGirl.create(:lab, referee: referee)
    new_lab.referee_approval_processes.create(referee_lab: arc)
    new_lab.referee_approval_processes.create(referee_lab: san)
    new_lab.referee_approval_processes.create(referee_lab: ath)
    sign_in lab_admin_arc
    expect(lab_admin_arc.is_referee?).to eq(true)
    visit backstage_lab_path(new_lab)
    click_button "Referee approves"
    expect(page).to have_content("Lab referee approved")
    updated_lab = Lab.find(new_lab.id)
    expect(updated_lab.workflow_state).to eq("referee_approval")
    sign_out lab_admin_arc

    sign_in lab_admin_san
    expect(lab_admin_san.is_referee?).to eq(true)
    visit backstage_lab_path(new_lab)
    click_button "Referee approves"
    expect(page).to have_content("Lab referee approved")
    updated_lab = Lab.find(new_lab.id)
    expect(updated_lab.workflow_state).to eq("approved")
    sign_out lab_admin_san
  end

  scenario "referees requests more info" do
    new_lab = FactoryGirl.create(:lab, referee: referee)
    new_lab.referee_approval_processes.create(referee_lab: arc)
    new_lab.referee_approval_processes.create(referee_lab: san)
    new_lab.referee_approval_processes.create(referee_lab: ath)

    sign_in lab_admin_arc
    expect(lab_admin_arc.is_referee?).to eq(true)
    visit backstage_lab_path(new_lab)
    click_button "Request more info"
    expect(page).to have_content("Lab requested more info")
    updated_lab = Lab.find(new_lab.id)
    expect(updated_lab.workflow_state).to eq("need_more_info")
  end

  scenario "referees requests admin approval" do
    new_lab = FactoryGirl.create(:lab, referee: referee)
    new_lab.referee_approval_processes.create(referee_lab: arc)
    new_lab.referee_approval_processes.create(referee_lab: san)
    new_lab.referee_approval_processes.create(referee_lab: ath)

    sign_in lab_admin_arc
    expect(lab_admin_arc.is_referee?).to eq(true)
    visit backstage_lab_path(new_lab)
    click_button "Referee requests admin approval"
    expect(page).to have_content("Lab referee requested admin approval")
    updated_lab = Lab.find(new_lab.id)
    expect(updated_lab.workflow_state).to eq("admin_approval")
  end

  scenario "referees approves-requests-more-info-approves approval" do
    new_lab = FactoryGirl.create(:lab, referee: referee)
    new_lab.referee_approval_processes.create(referee_lab: arc)
    new_lab.referee_approval_processes.create(referee_lab: san)
    new_lab.referee_approval_processes.create(referee_lab: ath)

    sign_in lab_admin_arc
    expect(lab_admin_arc.is_referee?).to eq(true)
    visit backstage_lab_path(new_lab)
    click_button "Referee approves"
    expect(page).to have_content("Lab referee approved")
    updated_lab = Lab.find(new_lab.id)
    expect(updated_lab.workflow_state).to eq("referee_approval")
    sign_out lab_admin_arc

    sign_in lab_admin_san
    expect(lab_admin_san.is_referee?).to eq(true)
    visit backstage_lab_path(new_lab)
    click_button "Request more info"
    expect(page).to have_content("Lab requested more info")
    updated_lab = Lab.find(new_lab.id)
    expect(updated_lab.workflow_state).to eq("need_more_info")

    updated_lab.update_attributes(workflow_state: :more_info_added)
    updated_lab.employees.update_all(workflow_state: :more_info_added)
    updated_lab.more_info_added
    new_updated_lab = Lab.find(updated_lab.id)

    visit backstage_lab_path(new_updated_lab)
    click_button "Referee approves"
    expect(page).to have_content("Lab referee approved")
    newest_updated_lab = Lab.find(new_updated_lab.id)
    expect(newest_updated_lab.workflow_state).to eq("approved")
  end

end
