# coding: utf-8
class Ruler < ActiveRecord::Base

  validates :gvdate,
    presence: true,
    length: {maximum: 10}
  validates :fort_group,
    presence: true,
    length: {maximum: 10}
  validates :fort_code,
    presence: true,
    length: {maximum: 10}
  validates :fort_name,
    allow_nil: true,
    length: {maximum: 100}
  validates :formal_name,
    allow_nil: true,
    length: {maximum: 100}
  validates :guild_name,
    presence: true,
    length: {maximum: 50}
  validates :source,
    presence: true,
    length: {maximum: 50}

  scope :for_date,  lambda{|d| where(gvdate: d)}
  scope :for_group, lambda{|g| where(fort_group: g)}

  class << self

    def gvdates
      self.uniq(:gvdate).pluck(:gvdate).sort
    end

  end

end
